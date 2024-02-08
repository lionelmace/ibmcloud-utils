# Learn terraform on IBM Cloud

This lab will provision a VPC, a Subnet, a Client to Server VPN in a new Resource Group within IBM Cloud.

![](./images/graph.svg)

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
