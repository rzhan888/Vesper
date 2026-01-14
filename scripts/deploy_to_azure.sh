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
DB_SERVER_NAME="psql-vesper-ai-$RANDOM" # Unique name
DB_NAME="webui"

echo "Deploying Vesper to Azure..."
echo "Resource Group: $RESOURCE_GROUP"
echo "Location: $LOCATION"
echo "DB Server: $DB_SERVER_NAME"

# 1. Create Resource Group
echo "Creating Resource Group..."
az group create --name $RESOURCE_GROUP --location $LOCATION

# 1.5 Create PostgreSQL Flexible Server
echo "Creating PostgreSQL Flexible Server (This may take a few minutes)..."
az postgres flexible-server create \
  --resource-group $RESOURCE_GROUP \
  --name $DB_SERVER_NAME \
  --location $LOCATION \
  --admin-user $POSTGRES_USER \
  --admin-password $POSTGRES_PASSWORD \
  --sku-name Standard_B1ms \
  --tier Burstable \
  --version 16 \
  --storage-size 32 \
  --database-name $DB_NAME \
  --public-access 0.0.0.0 \
  --yes

echo "Constructing Database URL..."
# DATABASE_URL specific format for Open WebUI (SQLAlchemy)
# postgresql://user:password@host:5432/dbname
DATABASE_URL="postgresql://$POSTGRES_USER:$POSTGRES_PASSWORD@$DB_SERVER_NAME.postgres.database.azure.com:5432/$DB_NAME"

# 2. Create Container Apps Environment
echo "Creating Container Apps Environment..."
az containerapp env create \
  --name $CONTAINER_APPS_ENV \
  --resource-group $RESOURCE_GROUP \
  --location $LOCATION

# 3. Create Container App (Enterprise Configuration)
echo "Creating Container App with Auto-scaling..."
az containerapp create \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --environment $CONTAINER_APPS_ENV \
  --image $IMAGE_NAME \
  --target-port 8080 \
  --ingress external \
  --query properties.configuration.ingress.fqdn \
  --cpu 2.0 --memory 4.0Gi \
  --min-replicas 2 \
  --max-replicas 10 \
  --scale-rule-name cpu-scale \
  --scale-rule-type cpu \
  --scale-rule-metadata type=utilization value=70 \
  --env-vars \
    OPENAI_API_BASE_URL=$OPENAI_API_BASE_URL \
    OPENAI_API_KEY=$OPENAI_API_KEY \
    WEBUI_AUTH=true \
    DATABASE_URL=$DATABASE_URL \
    ENABLE_OAUTH_SIGNUP=$ENABLE_OAUTH_SIGNUP \
    OAUTH_PROVIDER_NAME=$OAUTH_PROVIDER_NAME \
    OAUTH_CLIENT_ID=$OAUTH_CLIENT_ID \
    OAUTH_CLIENT_SECRET=$OAUTH_CLIENT_SECRET \
    ACCESS_TOKEN_SECRET=$ACCESS_TOKEN_SECRET

echo "Deployment complete!"
