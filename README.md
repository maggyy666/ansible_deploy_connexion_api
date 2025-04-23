# Ansible Deployment for Connexion API (macOS only)

This repository contains an Ansible-based setup to deploy the [Connexion API](https://github.com/maggyy666/connexion_api) using Docker Compose on macOS.

It builds the Docker image and launches services like OpenSearch defined in the adjacent `connexion_api/` repository.

---

## Requirements (macOS)

- [Docker Desktop](https://www.docker.com/products/docker-desktop)
- Python 3.10+
- Homebrew
- Ansible
- community.docker Ansible collection

---

## Project Setup

Place both repositories in the **same parent folder**, for example:

📂 your-folder/ 

├── ansible_deploy_connexion_api/ ← this repo 

├── connexion_api/ ← cloned here


---

###  Clone both repositories:

```bash
git clone https://github.com/maggyy666/connexion_api.git
git clone https://github.com/maggyy666/ansible_deploy_connexion_api.git
```

### Build the Docker image
From `ansible_deploy_connexion_api` directory:
```bash
brew install ansible
ansible-galaxy collection install community.docker
ansible-playbook playbook.yml
```
This will build the `connexion-api:latest` Docker image locally.

### Deploying with Kubernetes (Kind)
1. **Install Kind and create local cluster**
(Make sure your `king-config.yaml` contains `extraPortMappings` for both services.)
```bash
brew install kind
kind create cluster --config k8s/kind-config.yaml --name connexion-cluster
```
Example `kind-config`:
```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
name: connexion-cluster
nodes:
  - role: control-plane
    extraPortMappings:
      - containerPort: 30080
        hostPort: 30080
        protocol: TCP
      - containerPort: 9200
        hostPort: 30920
        protocol: TCP
```

2. **Load the image into the cluster**
```bash
kind load docker-image connexion-api:latest --name connexion-cluster
```
3. **Create secret for OpenSearch credentials**

File: `k8s/opensearh-secret.yaml`
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: opensearch-secret
type: Opaque
stringData:
  OPENSEARCH_USER: username
  OPENSEARCH_PASSWORD: password
```
Apply it:
```bash
kubectl apply -f k8s/opensearch-secret.yaml
```

4. **Apply Kubernetes manifests**
```bash
kubectl apply -f k8s/opensearch-deployment.yaml
kubectl apply -f k8s/opensearch-service.yaml
kubectl apply -f k8s/connexion-deployment.yaml
kubectl apply -f k8s/connexion-service.yaml
```
Check status:
```bash
kubectl get pods
kubectl get svc
```
You should see both `opensearch` and `connexion-api-service` with `NodePort` values (e.g. 30080)

## Accessing the Services
Swagger UI (Connexion API):
```bash
http://localhost:30080/ui
```
Test `/tenants` endpoint:
```bash
curl http://localhost:30080/ui
```