# Test Cloud Logs

## Pre-Requisites

* Install yq `brew install yq`
* Install oc CLI

## How to install

1. Download the Cloud Logs Routing agent configuration file

   ```sh
   curl -sSL https://ibm.biz/iclr-agent-yaml -o logger-agent.yaml
   ```

1. Set the API Key

   ```sh
   export IAMAPIKey="<your-api-key>"
   ```

1. Install agent

    ```sh
   curl -sSL https://ibm.biz/logs-router-setup | bash -s -- \
     -v 1.3.2 \
     -m IAMAPIKey \
     -k $IAMAPIKey \
     -t OpenShift \
     -r eu-de \
     --send-directly-to-icl \
     -h 3f019d15-c402-4328-886d-7147e5c4ff50.ingress.eu-de.logs.cloud.ibm.com \
     -p 443 \
     -d ~/mygit/ibmcloud-utils/cloud-logs/
    ```

## Resources

* [Send IBM Cloud Kubernetes Service log data to IBM Cloud Logs](https://cloud.ibm.com/docs/cloud-logs?topic=cloud-logs-kube2logs)