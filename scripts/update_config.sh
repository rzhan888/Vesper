#!/bin/bash
set -e

# Load environment variables
if [ -f .env.azure ]; then
    export $(cat .env.azure | xargs)
else
    echo "Error: .env.azure not found."
    exit 1
fi

RESOURCE_GROUP="rg-vesper-ai"
APP_NAME="vesper-chat"

echo "Updating Vesper Configuration..."
echo "Resource Group: $RESOURCE_GROUP"
echo "App Name: $APP_NAME"

az containerapp update \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --set-env-vars \
    OPENAI_API_BASE_URL=$OPENAI_API_BASE_URL \
    OPENAI_API_KEY=$OPENAI_API_KEY \
    ENABLE_OAUTH_SIGNUP=$ENABLE_OAUTH_SIGNUP \
    OAUTH_PROVIDER_NAME=$OAUTH_PROVIDER_NAME \
    OAUTH_CLIENT_ID=$OAUTH_CLIENT_ID \
    OAUTH_CLIENT_SECRET=$OAUTH_CLIENT_SECRET \
    ACCESS_TOKEN_SECRET=$ACCESS_TOKEN_SECRET

echo "Update complete!"
