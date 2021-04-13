# Satellite demo

This shell script will prepare for you a Satellite demo environement. 
It will create those resources unless the names you provided match an existing instance:

* Resource Group
* VPC, Subnet, Public Gateway
* Satellite location
* 6 VSIs in VPC
* Assign 3 hosts for the location control plane.

> All the resources will be created with the prefix **sat**.
> The script does not provision the OpenShift cluster in the location.

## Pre Requisites

* IBM Cloud CLI available [here](https://github.com/IBM-Cloud/ibm-cloud-cli-release/releases)
* Install VPC Infrastructure plugin `ibmcloud plugin install infrastructure-service`
* Install COS Plugin `ibmcloud plugin install cloud-object-storage`

## How to run it?

> Approximate Duration time: 10-12 mins

1. Launch a terminal.

1. Connection to IBM Cloud
    ```
    ibmcloud login
    ```

1. Clone this repo
    ```
    git clone https://github.com/lionelmace/ibmcloud-utils/
    ```

1. Go to directory satellite
    ```
    cd ibmcloud-utils/satellite
    ```

1. Copy the environnement variables
    ```
    cp satellite.env.template satellite.env
    ```

1. Set your location name
    ```
    export SATELLITE_LOCATION_NAME=YOUR_LOCATION_NAME
    ```
    > This is optional if you have set the location name in the satellite.env. Othwerise, this will override the location name

1. Run the script
    ```
    ./satellite-create.sh
    ```

## Clean up to avoid costs

> Approximate Duration time: 2-3 mins

1. Run the script
    ```
    ./satellite-remove.sh
    ```
