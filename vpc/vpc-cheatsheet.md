# Pre-Requisites	

+ Get a [IBM Cloud account](https://cloud.ibm.com)	
+ Install the [IBM Cloud CLI](https://github.com/IBM-Cloud/ibm-cloud-cli-release/releases/)	


# Steps	

1. [Step 1 - Install IBM Cloud Infrasctructure plugin](#step-1---install-ibm-cloud-infrastructure-plugin)	
1. [Step 2 - Connect to IBM Cloud](#step-2---connect-to-ibm-cloud)	
1. [Step 3 - Show Infrastructure and Region commands](#step-3---show-infrastructure-and-region-commands)	
1. [Step 4 - Create VPC](#step-2---create-vpc)	


# Step 1 - Install IBM Cloud Infrasctructure plugin	

To create VPC, and VSI, install the Infrastructure plug-in.	

1. Open a command line utility.	

1. Before installing the Infrastructure plugin, we need to add the repository hosting IBM Cloud CLI plug-ins.	
    ```	
    ibmcloud plugin repos	
    ```	
    Output:	
    ```	
    Listing added plug-in repositories...

    Repo Name   URL                             Description
    IBM Cloud   https://plugins.cloud.ibm.com   Official repository(Formerly named 'Bluemix')
    ```	

1. If you don't see a repository, run the following command:	
    ```	
    ibmcloud plugin repo-add "IBM Cloud" https://plugins.cloud.ibm.com
    ```	

1. To install the Infrastructure Service plugin, run the following command:	
    ```	
   ibmcloud plugin install infrastructure-service	
    ```	

1. To verify that the plug-in is installed properly, run the following command:	
    ```	
    ibmcloud plugin list	
    ```	
    and both plug-ins are displayed in the results:	
    ```	
    Listing installed plug-ins...	
    Plugin Name          Version	
    vpc-infrastructure/infrastructure-service   0.5.8	
    ```	

1. To update the plugin	
    ```	
    ibmcloud plugin update	
    ```	


# Step 2 - Connect to IBM Cloud	

1. Login to IBM Cloud	
    ```	
    ibmcloud login	
    ```	

1. Select the region (API Endpoint) where you deployed your application.	

    | Location | Acronym |
    | ----- | ----------- |
    |Germany|eu-de|
    |Sydney|au-syd|
    |US East|us-east|
    |US South|us-south|
    |United Kingdom|eu-gb|

    >  To switch afterwards to a different region, use the command `ibmcloud target -r eu-de`	


# Step 3 - Show Infrastructure and Region commands	

1. Get the list of all Infrastructure commands	
    ```	
    ibmcloud is help	
    ```	

1. IBM Cloud offers has two generations of Infrastructure. Gen 2 offers 5 times faster provisioning. Note Gen 2 is only available in Dallas. Select Gen 1 to work in Frankfurt.
    ```
    ibmcloud is target --gen 1
    ```

1. List all regions	
    ```	
    ibmcloud is regions	
    ```	

1. List all zones in a region	
    ```	
    ibmcloud is zones eu-de
    ```	
    Output:
    ```
    Listing regions for generation 1 compute under account Demo as user first.last@fr.ibm.com...
    Name       Endpoint                              Status
    eu-gb      https://eu-gb.iaas.cloud.ibm.com      available
    au-syd     https://au-syd.iaas.cloud.ibm.com     available
    jp-tok     https://jp-tok.iaas.cloud.ibm.com     available
    eu-de      https://eu-de.iaas.cloud.ibm.com      available
    us-south   https://us-south.iaas.cloud.ibm.com   available
    ```


# Step 4 - Create VPC	

1. List all VPCs in the account	
    ```	
    ibmcloud is vpcs	
    ```	

1. Create a VPC	
    ```	
    ibmcloud is vpc-create test-vpc-lma	
    ```	


# Step 5 - Create subnets	
```	
ibmcloud is subnet-create Z2-S1-P $vpc eu-de-1 --ipv4_cidr_block 10.1.1.0/24	
```	
```	
ibmcloud is subnet-create Z2-S2-A $vpc eu-de-2 --ipv4_cidr_block 10.1.2.0/24	
```	
```	
ibmcloud is subnet-create Z2-S3-D $vpc eu-de-3 --ipv4_cidr_block 10.1.3.0/24	
```	
```	
ibmcloud is subnets	
```	


# Create public gateway	
```	
ibmcloud is public-gateway-create Gateway-Z2-S2-A $vpc us-south-2	
```	
```	
ibmcloud is pubgws	
```	
```	
$gateway="7749299f-7503-4fe7-a177-6fbbef95b9a6"	
```	
```	
ibmcloud is subnet-update $a --gw $gateway	
```	
```	
ibmcloud is subnets	
```	

# Add key	
```	
ibmcloud is key-create --name demo-key-ibm --key "ssh-rsa XXXXXXXXXX==" --rg 1	
```	
```	
ibmcloud is keys	
```	
```	
$key="8cda4a00-946c-47ad-8044-bbc3bb09fbd1"	
```	

# Show images & profiles	
```	
ibmcloud is images	
```	
```	
$image="cc8debe0-1b30-6e37-2e13-744bfb2a0c11"	
```	
```	
ibmcloud is instance-profiles	
```	
```	
$profile="c-1x1"	
```	

# Create VMs	
```	
ibmcloud is instance-create P1 $vpc us-south-2 $profile $p 1000 --image $image --keys $key	
```	
```	
ibmcloud is instance-create A1 $vpc us-south-2 $profile $a 1000 --image $image --keys $key	
```	
```	
ibmcloud is instance-create D1 $vpc us-south-2 $profile $d 1000 --image $image --keys $key	
```	
```	
ibmcloud is instances	
```	

# Create floating IP	
```	
ibmcloud is instance 66f31a3d-09d1-44a9-b7fe-e6b716737273	
```	
```	
$nic="53f8d4e4-5531-4cf5-8388-157ce65ffac6"	
```	
```	
ibmcloud is floating-ip-reserve VIP-P1 --nic $nic	
```