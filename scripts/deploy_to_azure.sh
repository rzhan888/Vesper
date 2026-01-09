#!/bin/bash
set -e

# Load environment variables
if [ -f .env.azure ]; then
    export $(cat .env.azure | xargs)
elif [ -f .env.azure.template ]; then
    echo "WARNING: .env.azure not found. Using .env.azure.template for validation."
    # We don't export template vars as they are placeholders, just warning.
    echo "Please copy .env.azure.template to .env.azure and fill in the values before running."
    exit 1
else
    echo "Error: .env.azure not found."
    exit 1
fi

# Variables
RESOURCE_GROUP="rg-vesper-ai"
LOCATION="eastus"
CONTAINER_APPS_ENV="cae-vesper-ai"
APP_NAME="vesper-chat"
IMAGE_NAME="ghcr.io/open-webui/open-webui:main"

echo "Deploying Vesper to Azure..."
echo "Resource Group: $RESOURCE_GROUP"
echo "Location: $LOCATION"

# 1. Create Resource Group
echo "Creating Resource Group..."
az group create --name $RESOURCE_GROUP --location $LOCATION

# 2. Create Container Apps Environment
echo "Creating Container Apps Environment..."
az containerapp env create \
  --name $CONTAINER_APPS_ENV \
  --resource-group $RESOURCE_GROUP \
  --location $LOCATION

# 3. Create Container App
echo "Creating Container App..."
az containerapp create \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --environment $CONTAINER_APPS_ENV \
  --image $IMAGE_NAME \
  --target-port 8080 \
  --ingress external \
  --query properties.configuration.ingress.fqdn \
  --cpu 2.0 --memory 4.0Gi \
  --env-vars \
    OPENAI_API_BASE_URL=$OPENAI_API_BASE_URL \
    OPENAI_API_KEY=$OPENAI_API_KEY \
    WEBUI_AUTH=true \
    ENABLE_OAUTH_SIGNUP=$ENABLE_OAUTH_SIGNUP \
    OAUTH_PROVIDER_NAME=$OAUTH_PROVIDER_NAME \
    OAUTH_CLIENT_ID=$OAUTH_CLIENT_ID \
    OAUTH_CLIENT_SECRET=$OAUTH_CLIENT_SECRET \
    ACCESS_TOKEN_SECRET=$ACCESS_TOKEN_SECRET

echo "Deployment complete!"
