# Day 1 Deployment Checklist

This checklist is for the DevOps engineer to execute the moment Azure access is granted.

## Prerequisites

- [ ] Azure Subscription active.
- [ ] `az` CLI installed and logged in (`az login`).
- [ ] `git` installed.

## 1. Credentials Setup

- [ ] **OpenAI Keys**: Obtain `OPENAI_API_BASE_URL` and `OPENAI_API_KEY` from the Azure Portal.
- [ ] **App Registration**: Submit the `docs/IT_REQUEST_SPECS.md` to IT and receive:
  - `OAUTH_CLIENT_ID`
  - `OAUTH_CLIENT_SECRET` (Value)

## 2. Configuration

- [ ] Copy template: `cp .env.azure.template .env.azure`
- [ ] Fill in `.env.azure` with the values from Step 1.
- [ ] Ensure `ACCESS_TOKEN_SECRET` is populated (it should be pre-filled).

## 3. Deployment

- [ ] Run the deployment script:
  ```bash
  ./scripts/deploy_to_azure.sh
  ```
- [ ] Wait for the script to complete (approx. 5-10 mins).
- [ ] Note the FQDN (URL) output at the end of the script.

## 4. Post-Deployment Verification

- [ ] Visit the URL provided.
- [ ] Test "Sign in with Microsoft".
- [ ] Verify you can chat with the AI.
- [ ] Send the URL to the team!

## 5. Updates

- [ ] If you need to rotate keys or update the image, edit `.env.azure` and run:
  ```bash
  ./scripts/update_config.sh
  ```
