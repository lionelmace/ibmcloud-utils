# Learn terraform on IBM Cloud

This lab will provision a VPC, a Subnet, a Client to Server VPN in a new Resource Group within IBM Cloud.

| Terraform | Duration |
| --------- | --------- |
| Apply     | ~7 mins |
| Destroy   | ~5 mins |

## Before you begin

This lab requires the following command lines:

* [IBM Cloud CLI](https://github.com/IBM-Cloud/ibm-cloud-cli-release/releases)
* [Terraform CLI](https://developer.hashicorp.com/terraform/downloads)
* [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

## Lab

1. Clone this repository

    ```sh
    git clone https://github.com/lionelmace/ibmcloud-utils
    ```

1. Go to the VPN folder

    ```sh
    cd terraform/vpn
    ```

1. Create an IBM Cloud API either in the [console](https://cloud.ibm.com/iam/apikeys) or using the CLI

    ```sh
    ibmcloud iam api-key-create my-api-key
    ```

    > Make sure to preserve the API Key.

1. Export API credential tokens as environment variables

    ```sh
    export TF_VAR_ibmcloud_api_key="Your IBM Cloud API Key"
    ```

    > Required only if terraform is launched outside of Schematics.

1. Terraform must initialize the provider before it can be used.

    ```sh
    terraform init
    ```

1. Review the plan

    ```sh
    terraform plan
    ```

1. Start provisioning.

    ```sh
    terraform apply -var-file="testing.auto.tfvars"
    ```

1. Clean up the resources to avoid cost

    ```sh
    terraform destroy
    ```

1. Terraform fails to delete VPN Server Route

    ```sh
    ibm_is_vpn_server_route.route_nating: Still destroying... [id=r010-f039cf1b-49c4-43a9-b0c1-3ad877f463...0-7d6cd7ae-7d19-4c09-86a8-49b70c7f2a7b, 10m0s elapsed]
    ibm_is_vpn_server_route.route_cse_to_vpc: Still destroying... [id=r010-f039cf1b-49c4-43a9-b0c1-3ad877f463...0-288ee7be-395d-4f03-8615-51a454e172b9, 10m0s elapsed]
    ibm_is_vpn_server_route.route_private_to_vpc: Still destroying... [id=r010-f039cf1b-49c4-43a9-b0c1-3ad877f463...0-1ff99a76-4124-4b34-8694-9495e39e6d88, 10m0s elapsed]
    Error: [ERROR] VPNServer Route failed timeout while waiting for state to become 'deleted, failed' (last state: 'deleting', timeout: 10m0s)
    Error: [ERROR] VPNServer Route failed timeout while waiting for state to become 'deleted, failed' (last state: 'deleting', timeout: 10m0s)
    Error: [ERROR] VPNServer Route failed timeout while waiting for state to become 'deleted, failed' (last state: 'deleting', timeout: 10m0s)
    ```