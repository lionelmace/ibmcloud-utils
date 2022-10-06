#!/bin/bash
# APIKEY=
# REGION=
# CLUSTER_ID=
# SECRETS_MANAGER_ID=
set -e -o pipefail

# install IBM Cloud CLI (not required if running in Schematics)
# curl -fsSL https://clis.cloud.ibm.com/install/linux | sh

# use IBM Cloud CLI to interact with Secrets Manager
ibmcloud login --apikey $APIKEY -r $REGION
ibmcloud plugin install secrets-manager -f

# retrieve the URL of the Secrets Manager instance
secrets_manager_json=$(ibmcloud resource service-instance $SECRETS_MANAGER_ID --output json | jq '.[0]')
secrets_manager_url=https://$(echo $secrets_manager_json | jq -r '.extensions.virtual_private_endpoints | .dns_hosts[0]').${REGION}.secrets-manager.appdomain.cloud
echo "Secrets Manager URL is $secrets_manager_url"

# create a secret group
# echo "Creating a secret group..."
# ibmcloud secrets-manager secret-group-create \
#   --resources='[
#     {
#       "name": "custom-image-observability",
#        "description": "Created by terraform as part of the custom-image example."
#     }
#   ]' \
#   --output json \
#   --service-url $secrets_manager_url

# attach the secrets manager instance to the cluster
echo "Attaching the secrets manager..."
ibmcloud ks ingress instance register \
    --cluster $CLUSTER_ID \
    --crn $SECRETS_MANAGER_ID \
    --is-default

ibmcloud logout