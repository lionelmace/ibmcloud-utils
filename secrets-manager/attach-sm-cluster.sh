
#!/bin/sh
# Uncommment to verbose
# set -x 

source ./local.env

ibmcloud login -g $RG_NAME -r $IBMCLOUD_REGION --apikey $APIKEY

export SECRETS_MANAGER_URL=https://$SM_ID.$IBMCLOUD_REGION.secrets-manager.appdomain.cloud

# attach the secrets manager instance to the cluster
echo "Attaching the secrets manager..."
ibmcloud ks ingress instance register \
    --cluster $CLUSTER_ID \
    --crn $SECRETS_MANAGER_ID \
    --is-default

# Verify that the Secrets Manager instance was registered to the cluster. 
ibmcloud ks ingress instance ls --cluster $CLUSTER_ID

# ibmcloud oc cluster get --cluster $CLUSTER_ID | grep Ingress

# ibmcloud oc ingress secret ls -c $CLUSTER_ID


# Create a Secrets Group
# ibmcloud secrets-manager secret-group-create \
#     --resources='[{"name": "my-secret-group", "description": "Extended description for this group."}]'

# SM_GROUP_ID=$(ibmcloud secrets-manager secret-group-create \
#     --resources='[{"name": "new-secret-group3", "description": "Extended description for this group."}]' \
#                                         --output json \
#                                         | jq -r '.resources.id')
# echo $SM_GROUP_ID

# Create a secret
#export SECRET_ID=`ibmcloud secrets-manager secret-create --secret-type username_password  --resources '[{"name":"example_username_password","description":"Extended description for my secret.","secret_group_id":"'"$SECRET_GROUP_ID"'","username":"user123","password":"cloudy-rainy-coffee-book","labels":["my-test-cluster","tutorial"]}]' --output json | jq -r ".resources[].id"`; echo $SECRET_ID
ibmcloud secrets-manager secret-create --secret-type username_password \
  --resources '[{"name":"mongodb-credentials","description":"Mongo DB Credentials","username":"user123","password":"cloudy-rainy-coffee-book","labels":["my-test-cluster","tutorial"]}]'

# ibmcloud secrets-manager secret-create \
#     --secret-type=arbitrary \
#     --resources='[{"name": "example-arbitrary-secret", "description": "Extended description for this secret.", "labels": ["dev","us-south"], "custom_metadata": {"anyKey": "anyValue"}, "version_custom_metadata": {"anyKey": "anyValue"}, "expiration_date": "2030-01-01T00:00:00Z", "payload": "secret-data"}]'
    # --resources='[{"name": "example-arbitrary-secret", "description": "Extended description for this secret.", "secret_group_id": "bc656587-8fda-4d05-9ad8-b1de1ec7e712", "labels": ["dev","us-south"], "custom_metadata": {"anyKey": "anyValue"}, "version_custom_metadata": {"anyKey": "anyValue"}, "expiration_date": "2030-01-01T00:00:00Z", "payload": "secret-data"}]'

# List SM groups
# ibmcloud secrets-manager secret-groups

# Step 1 - Run the command to set the new default instance.
# You can optionally specify a secret group that is allowed access to the secrets in the instance.
#ibmcloud ks ingress instance default set --cluster $CLUSTER_ID --name <instance_name> --secret-group <secret_group_id>