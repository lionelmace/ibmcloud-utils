# Satellite demo

This shell script will prepare for you a Satellite demo environement. 
It will create those resources unless the names you provided match an existing instance:

* Resource Group
* VPC, Subnet, Public Gateway
* Satellite location
* 6 VSIs in VPC
* Assign 3 hosts for the location control plane.

> This script does not create the OpenShift cluster in the location.

## Pre Requisites

* IBM Cloud CLI
* COS Plugin

## How to run it?

> Approximate Duration time: 10-12 mins

1. Launch [IBM Cloud Shell](http://cloud.ibm.com/shell)

1. Clone this repo
    ```
    git clone https://github.com/lionelmace/ibmcloud-utils/
    ```

1. Go to directory satellite
    ```
    cd ibmcloud-utils/satellite
    ```

1. Create your custom satellite.env file
    ```
    cp satellite.env.template satellite.env
    ```

1. Edit satellite.env to edit the name of your location
    ```
    export LOCATION_NAME=YOUR_LOCATION_NAME
    ```

1. Run the script
    ```
    ./satellite-create.sh
    ```

## Clean up to avoid costs

1. Run the script
    ```
    ./satellite-remove.sh
    ```
