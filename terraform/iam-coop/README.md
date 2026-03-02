APIKEY=$(ibmcloud iam service-api-key-create my-svcid-key coop-svc-id \
  | grep "API Key" \
  | awk '{print $NF}')

export TF_VAR_ibmcloud_api_key="$APIKEY"