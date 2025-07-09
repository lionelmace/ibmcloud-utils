# Configure COS Registry

This tutorial explains how to configure a COS (Cloud Object Storage) bucket for your cluster.

## Pre-Requisites

You should already have both an existing ROKS (Red Hat OpenShift on IBM Cloud) cluster and a COS instance.

## Steps

1. Set some variables

    ```sh
    export CLUSTER_NAME=<your-cluster-name>
    export COS_INSTANCE_ID=<your-cos-instance-id>
    export CLUSTER_ID=$(ibmcloud ks cluster get --cluster $CLUSTER_NAME --json | jq -r .id)
    ```

1. Check the image registry operator

    ```sh
    oc get configs.imageregistry.operator.openshift.io/cluster -o yaml
    ```

1. Temporarily set the operator to Removed mode.
   If the registry is already active, disable it to avoid conflicts:

    ```sh
    oc patch configs.imageregistry.operator.openshift.io/cluster \
    --type=merge -p '{"spec":{"managementState":"Removed"}}'
    ```

1. Check if the registry uses emptyDir, which means no COS bucket is configured:

    ```yaml
    storage:
      emptyDir: {}
      managementState: Managed
    ```

1. Create a COS bucket

    ```sh
    RANDOM_SUFFIX=$(LC_ALL=C tr -dc 'a-z0-9' </dev/urandom | head -c 6)
    BUCKET_NAME="roks-${CLUSTER_ID}-${RANDOM_SUFFIX}"
    ibmcloud cos bucket-create \
      --bucket "$BUCKET_NAME" \
      --ibm-service-instance-id "$COS_INSTANCE_ID" \
      --class standard \
      --region eu-de
    ```

1. Store the bucket name in a variable

    ```sh
    COS_BUCKET_NAME=<your-cos-bucket-name>
    ```

1. Configure the registry to use S3 storage (COS)

    ```sh
    oc patch configs.imageregistry.operator.openshift.io/cluster --type=merge -p "$(cat <<EOF
    {
    "spec": {
      "managementState": "Unmanaged",
        "storage": {
          "s3": {
            "bucket": "$COS_BUCKET_NAME",
            "region": "eu-de-standard",
            "regionEndpoint": "https://s3.direct.eu-de.cloud-object-storage.appdomain.cloud",
            "trustedCA": {
              "name": ""
            },
            "virtualHostedStyle": false
          }
        }
      }
    }
    EOF
    )"
    ```

1. Create a service credential key for the COS instance and store it to a file

    ```sh
    ibmcloud resource service-key-create roks-$CLUSTER_ID-key \
    --instance-id "$COS_INSTANCE_ID" \
    -p '{"HMAC": true}' \
    -o json > service-key.json

    # Extract values with jq
    ACCESS_KEY=$(jq -r '.credentials.cos_hmac_keys.access_key_id' service-key.json)
    SECRET_KEY=$(jq -r '.credentials.cos_hmac_keys.secret_access_key' service-key.json)

    # Create credentials file
    cat <<EOF > creds.txt
    [default]
    aws_access_key_id = $ACCESS_KEY
    aws_secret_access_key = $SECRET_KEY
    EOF
    ```

    > This creates a creds.txt file with content like:

    ```sh
    [default]
    aws_access_key_id = f1ab5fcf7XXXXXXXXXb2a14e046
    aws_secret_access_key = 4c78ddfa763XXXXXXX23d1cc9350d1
    ```

1. Patch the secret used by the image registry to set the access credentials (user)

    ```sh
    kubectl patch secret image-registry-private-configuration-user \
    -n openshift-image-registry \
    --type merge \
    -p "{
        \"data\": {
        \"REGISTRY_STORAGE_S3_ACCESSKEY\": \"$(echo -n "$ACCESS_KEY" | base64)\",
        \"REGISTRY_STORAGE_S3_SECRETKEY\": \"$(echo -n "$SECRET_KEY" | base64)\"
        }
    }"
    ```

1. Patch the main image registry secret with the full COS credentials file

    ```sh
    CREDENTIALS_B64=$(base64 -i creds.txt | tr -d '\n')

    kubectl patch secret image-registry-private-configuration \
    -n openshift-image-registry \
    --type merge \
    -p "{\"data\": {\"credentials\": \"${CREDENTIALS_B64}\"}}"
    ```

1. Set the image registry operator to Managed mode

    ```sh
    oc patch configs.imageregistry.operator.openshift.io/cluster \
    --type=merge -p '{"spec":{"managementState":"Managed"}}'
    ```

1. Restart the image registry deployment

    ```sh
    oc rollout restart deployment image-registry -n openshift-image-registry
    ```

1. Check that the registry is in a healthy state

    ```sh
    oc get clusteroperator image-registry
    ```
