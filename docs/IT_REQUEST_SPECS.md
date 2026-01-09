# IT Request Specifications: Company AI Chat App Registration

## Purpose

We require an Azure App Registration (Microsoft Entra ID) to enable Single Sign-On (SSO) for the new "Company AI Chat" application hosted on Azure Container Apps.

## Configuration Details

### 1. App Registration

- **Name**: Company AI Chat
- **Supported Account Types**: "Accounts in this organizational directory only" (Single Tenant)

### 2. Redirect URIs (Web)

Please add the following Redirect URI. Note that `<APP_NAME>` and `<REGION>` will depend on the final Azure Container App creation, but typically follow this pattern:

- `https://<APP_NAME>.<REGION>.azurecontainerapps.io/oauth/oidc/callback`

_Note: We may need to update this URI once the container app is provisioned._

### 3. Certificates & Secrets

- **Client Secret**: Please generate a new client secret.
  - **Description**: `Company AI Chat WebUI Secret`
  - **Expires**: Recommended 12 months (or per company policy).
  - **Action**: Please securely share the **Value** (not the Secret ID).

### 4. API Permissions

- **Microsoft Graph**:
  - `User.Read` (Delegated) - _Required for user sign-in and profile reading._
  - Grant Admin Consent for the organization if required.

## Deliverables

Please provide the following values back to the DevOps/Engineering team:

1.  **Application (client) ID**
2.  **Directory (tenant) ID**
3.  **Client Secret Value**
