
# Satellite Connector

## Installation Steps

1. Login to IBM Cloud Container Registry

    ```sh
    ibmcloud cr region-set icr.io
    ```

    ```sh
    export IBMCLOUD_API_KEY=XXXXXX
    ```

    ```sh
    docker login -u iamapikey -p $IBMCLOUD_API_KEY icr.io
    ```

1. Pull the docker image

    ```sh
    docker pull icr.io/ibm/satellite-connector/satellite-connector-agent:latest
    ```

1. Start the docker agent

    ```sh
    docker run -d --env-file ./agent-env-files/connector.env -v ~/mygit/ibmcloud-utils/satellite/agent-env-files:/agent-env-files icr.io/ibm/satellite-connector/satellite-connector-agent:v1.1.1
    ```

2. Verify the tunnel gets established

    ```sh
    docker logs CONTAINER-ID
    ```

3. Check available images

    ```sh
    ibmcloud cr images --include-ibm|grep connector
    ```

## Resources

* [Doc Running a Connector agent](https://cloud.ibm.com/docs/satellite?topic=satellite-run-agent-locally&interface=ui)