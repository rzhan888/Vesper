# Project Plan: Enterprise ChatGPT (Open WebUI + Azure) - Pre-flight Setup

**Objective:** Prepare a production-ready "Company ChatGPT" deployment package locally. The target architecture is Open WebUI hosted on Azure Container Apps, backed by Azure OpenAI and secured by Microsoft Entra ID.

**Current Status:** No Azure subscription access yet.
**Goal:** Generate all necessary configurations, scripts, and local testing environments so deployment takes < 15 minutes once access is granted.

---

## Phase 1: Local Environment Setup (MVP Simulation)

We will run Open WebUI locally using Docker to verify the UI, customize branding, and export basic configurations.

- [ ] **Step 1.1: Create Docker Compose File**

  - Create a `docker-compose.yml` file in the root directory.
  - Service: `open-webui`
  - Image: `ghcr.io/open-webui/open-webui:main`
  - Ports: `3000:8080`
  - Volumes: Mount local `./data` to `/app/backend/data` (to persist data locally).
  - Environment: Set `WEBUI_AUTH=true` to simulate a secured environment.

- [ ] **Step 1.2: Run Local Instance**

  - Execute `docker-compose up -d`.
  - Verify access at `http://localhost:3000`.
  - _Note to Agent:_ Do not proceed until the container is running and healthy.

- [ ] **Step 1.3: Generate Customization Assets**
  - Create a folder `assets/`.
  - Generate a placeholder `logo.png` (or ask user to provide one).
  - Create a text file `assets/system_prompt.txt` with a default corporate system prompt (e.g., "You are a helpful AI assistant for [Company Name]...").

---

## Phase 2: Azure Configuration Preparation (The "Fill-in-the-Blanks")

We will create the configuration files needed for the cloud environment, leaving placeholders for sensitive Azure credentials.

- [ ] **Step 2.1: Create Environment Variable Template**

  - Create a file named `.env.azure.template`.
  - Include the following keys with descriptive comments and placeholder values (e.g., `<INSERT_VALUE_HERE>`):
    - `OPENAI_API_BASE_URL` (Azure OpenAI Endpoint)
    - `OPENAI_API_KEY`
    - `ENABLE_OAUTH_SIGNUP` (Set to `true`)
    - `OAUTH_CLIENT_ID` (Entra ID Application ID)
    - `OAUTH_CLIENT_SECRET`
    - `OAUTH_PROVIDER_NAME` (Set to "Microsoft")
    - `ACCESS_TOKEN_SECRET` (Generate a random 32-char hex string for this now).

- [ ] **Step 2.2: Draft IT Request Document**
  - Create `docs/IT_REQUEST_SPECS.md`.
  - Write a clear specification for the IT Admin to create the App Registration.
  - Include:
    - App Name: "Company AI Chat"
    - Redirect URI Pattern: `https://<APP_NAME>.<REGION>.azurecontainerapps.io/oauth/oidc/callback`
    - API Permissions: `User.Read`.

---

## Phase 3: Infrastructure as Code (The Deployment Scripts)

We will write the Azure CLI scripts now, so we only need to copy-paste them later.

- [ ] **Step 3.1: Create Azure Deployment Script**

  - Create `scripts/deploy_to_azure.sh`.
  - This script should use `az` commands to:
    1. Set variables (Resource Group, Location, Env Name).
    2. Create Resource Group (`az group create`).
    3. Create Container App Environment (`az containerapp env create`).
    4. Create the Container App (`az containerapp create`).
  - _Critical:_ Ensure the `az containerapp create` command maps the variables from `.env.azure.template` to the container's environment.
  - Set CPU to `2.0` and Memory to `4.0Gi` to handle RAG/Embedding loads.

- [ ] **Step 3.2: Create Update Script**
  - Create `scripts/update_config.sh`.
  - This script allows updating environment variables (like rotating keys) without re-deploying the whole infrastructure.

---

## Phase 4: Documentation & Handover

Finalize the package for the user.

- [ ] **Step 4.1: Create User Manual**

  - Create `USER_GUIDE.md`.
  - Explain how to log in.
  - Explain how to upload documents for RAG.
  - Explain how to switch models.

- [ ] **Step 4.2: Create Final Deployment Checklist**
  - Create `DEPLOYMENT_CHECKLIST.md`.
  - A step-by-step list of what to do the moment the Azure subscription is active (e.g., "1. Get Key, 2. Fill .env, 3. Run script").
