# Satellite demo

This shell script will generate for you a demo environement.

## What does the script do for you?
It will create those resources unless the names you provided match an existing instance
* Resource Group
* VPC
* Subnet
* Public Gateway
* Satellite location
* 6 VSIs in VPC
* Assign 3 hosts for the location control plane.


## How to run it

1. Launch [IBM Cloud Shell](http://cloud.ibm.com/shell)

1. Clone this repo
    ```
    git clone https://github.com/lionelmace/ibmcloud-utils/
    ```

1. Go to directory satellite
    ```
    cd ibmcloud-utils/satellite
    ```

1. In the root directory, create your custom satellite.env file
    ```
    cp satellite.env.template satellite.env
    ```

1. Edit satellite.env to make the adjustments that you want

1. Make the script executable and run it
    ```
    chmod +x satellite-create.sh
    ./satellite-create.sh
    ```