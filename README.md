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
### Running the deployment
1. **Install Ansible and the required Docker plugin:**

   ```bash
   brew install ansible
   ansible-galaxy collection install community.docker
   ```
2. **Navigate to the deployment directory:**
    ```bash
    cd /path/to/your-folder/ansible_deploy_connexion_api
    ```

3. **Make sure the adjacent `connexion_api/` folder exists:**
    ```bash
    ls ../connexion_api
    ```
4. **Run the ansible playbook:**
    ```bash
    ansible-playbook playbook.yml
    ```

    This will:
    * Build the Docker image for the Connexion API
    * Start the API and OpenSearch using Docker Compose
