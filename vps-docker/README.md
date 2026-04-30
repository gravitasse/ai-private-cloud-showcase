# AI Private Cloud - VPS Docker Edition

This directory contains a lightweight, platform-agnostic "AI Cloud in a Box." While the root directory of this repository uses Terraform and Kubernetes to build a distributed cloud, this Docker Compose stack is designed to be easily deployed on a single Virtual Private Server (VPS) or a local machine.

## Open-Source Stack
This stack integrates several world-class open-source projects to give you a complete AI ecosystem instantly:

1. **[Ollama](https://ollama.com/)**: The core inference engine. It runs the Large Language Models (LLMs) locally.
2. **[Open WebUI](https://github.com/open-webui/open-webui)**: A beautiful, extensible frontend that connects to Ollama. It provides Role-Based Access Control (RBAC), chat history, and built-in Retrieval-Augmented Generation (RAG) so you can chat with your PDFs and documents.
3. **[n8n](https://n8n.io/)**: An advanced workflow automation platform. Because it shares the Docker network with Ollama, you can easily build autonomous AI agents that read emails, query the LLM, and take action.

## Deployment Instructions

### Prerequisites
- Docker and Docker Compose installed on your host.
- *(Optional but Highly Recommended)* If your VPS has a GPU, install the [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html).

### 1. Configuration
Copy the environment template and set your secure keys:
```bash
cp .env.example .env
```
Edit `.env` to set your `WEBUI_SECRET_KEY`.

### 2. Hardware Acceleration
If you are running on an NVIDIA GPU, open `docker-compose.yml` and uncomment the `deploy` block under the `ollama` service to pass the GPU into the container.

### 3. Start the Stack
Run the following command to start the AI Cloud:
```bash
docker compose up -d
```

### 4. Access Services
- **Open WebUI**: `http://localhost:3000`
- **n8n Automation**: `http://localhost:5678`
- **Ollama API**: `http://localhost:11434`

### Security Warning
If you are deploying this to a public VPS, **do not expose these ports directly to the internet**. You should put this stack behind a reverse proxy (like Traefik or Nginx Proxy Manager) configured with SSL certificates (Let's Encrypt) and basic authentication.
