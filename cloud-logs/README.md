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
   export IAMAPIKey="<your-api-key"
   ```

1. Install agent

    ```sh
    curl -sSL https://ibm.biz/logs-router-setup | bash -s -- \
      -v 1.2.2 \
      -m IAMAPIKey \
      -k $IAMAPIKey \
      -t OpenShift \
      -r eu-de \
      -p 443 \
      -d ./
    ```

## Resources

* https://test.cloud.ibm.com/docs/logs-router?topic=logs-router-agent-openshift