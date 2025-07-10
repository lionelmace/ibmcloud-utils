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
    COS_BUCKET_NAME="roks-${CLUSTER_ID}-${RANDOM_SUFFIX}"
    ibmcloud cos bucket-create \
      --bucket "$BUCKET_NAME" \
      --ibm-service-instance-id "$COS_INSTANCE_ID" \
      --class standard \
      --region eu-de
    ```

1. This command will explicitly remove the emptyDir field:

    ```sh
    oc patch configs.imageregistry.operator.openshift.io/cluster \
      --type=json \
      -p '[{"op": "remove", "path": "/spec/storage/emptyDir"}]'
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

1. Check the image registry operator

    ```sh
    oc get configs.imageregistry.operator.openshift.io/cluster -o yaml
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

1. Create the secret image-registry-private-configuration-user if it does not exist

    ```sh
    oc create secret generic image-registry-private-configuration-user -n openshift-image-registry
    ```

1. Patch the secret used by the image registry to set the access credentials (user)

    ```sh
    oc patch secret image-registry-private-configuration-user \
    -n openshift-image-registry \
    --type merge \
    -p "{
        \"data\": {
        \"REGISTRY_STORAGE_S3_ACCESSKEY\": \"$(echo -n "$ACCESS_KEY" | base64)\",
        \"REGISTRY_STORAGE_S3_SECRETKEY\": \"$(echo -n "$SECRET_KEY" | base64)\"
        }
    }"
    ```

1. Create the secret image-registry-private-configuration-user if it does not exist

    ```sh
    oc create secret generic image-registry-private-configuration -n openshift-image-registry
    ```

1. Patch the main image registry secret with the full COS credentials file

    ```sh
    CREDENTIALS_B64=$(base64 -i creds.txt | tr -d '\n')

    oc patch secret image-registry-private-configuration \
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

## Troubleshootings

1. Check the pod image-registry is running

    ```sh
    oc project openshift-image-registry
    oc get pods
    NAME                              READY   STATUS    RESTARTS   AGE
    image-registry-7d8b57c98f-m92t7   1/1     Running   0          3h53m
    node-ca-62p88                     1/1     Running   0          5h12m
    node-ca-6s8vx                     1/1     Running   0          5h17m
    node-ca-b5jwl                     1/1     Running   0          4h56m
    node-ca-chl7k                     1/1     Running   0          5h17m
    node-ca-l6tlb                     1/1     Running   0          4h55m
    node-ca-q4vw8                     1/1     Running   0          4h55m
    ```

1. Check the cluster operator image-registry

    ```sh
    oc describe clusteroperator image-registry
    ```

1. Removed the backend S3 to go back temporarily à emptyDir to unlock the operator.

    ```sh
    oc patch configs.imageregistry.operator.openshift.io/cluster --type=merge -p '{
    "spec": {
        "managementState": "Managed",
        "storage": {
        "emptyDir": {}
        }
    }
    }'
    ```

## Resources

* [Setting up and configuring the registry](https://docs.redhat.com/en/documentation/openshift_container_platform/4.7/html/registry/setting-up-and-configuring-the-registry#configuring-registry-storage-aws-user-infrastructure)
