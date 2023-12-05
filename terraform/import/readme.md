# Use Terraformer

## Pre-requisites

## Install

Install Step 1: https://github.com/GoogleCloudPlatform/terraformer

```sh
brew install terraformer
```

## Run

1. Set your Resource Group name and the Region

    ```sh
    export REGION=your_region
    export GROUP=your_resource_group
    ```

    Examples
    ```sh
    export REGION=eu-de
    export GROUP=icn-mrwqma-group
    ```


1. Generate Terraform file for your VPC

    ```sh
    terraformer import ibm --region=$REGION --resources=ibm_is_vpc --resource_group=$GROUP
    ```

    Output

    ```
    2023/12/05 14:13:32 ibm importing... ibm_is_vpc
    2023/12/05 14:13:34 ibm done importing ibm_is_vpc
    2023/12/05 14:13:34 Number of resources for service ibm_is_vpc: 0
    2023/12/05 14:13:34 ibm Connecting....
    2023/12/05 14:13:34 ibm save ibm_is_vpc
    2023/12/05 14:13:34 ibm save tfstate for ibm_is_vpc
    ```sh

1. Generate the Terraform files for your VPC Clusters

    ```sh
    terraformer import ibm --region=$REGION --resources=ibm_container_vpc_cluster --resource_group=$GROUP
    ```

    Output

    ```
    2023/12/05 14:32:05 ibm importing... ibm_container_vpc_cluster
    2023/12/05 14:32:11 ibm done importing ibm_container_vpc_cluster
    2023/12/05 14:32:11 Number of resources for service ibm_container_vpc_cluster: 2
    2023/12/05 14:32:11 Refreshing state... ibm_container_vpc_cluster.tfer--icn_mrwqma_iks
    2023/12/05 14:32:11 Refreshing state... ibm_container_vpc_cluster.tfer--icn_mrwqma_roks
    2023/12/05 14:32:17 Filtered number of resources for service ibm_container_vpc_cluster: 2
    2023/12/05 14:32:17 ibm Connecting....
    2023/12/05 14:32:17 ibm save ibm_container_vpc_cluster
    2023/12/05 14:32:17 ibm save tfstate for ibm_container_vpc_cluster
    ```

1. Generate the Terraform files for your VPC Clusters

    ```sh
    terraformer import ibm --region=$REGION --resources=ibm_database_mongo --resource_group=$GROUP
    ```

    Output

    ```sh
    2023/12/05 14:41:46 ibm importing... ibm_database_mongo
    2023/12/05 14:41:47 ibm done importing ibm_database_mongo
    2023/12/05 14:41:47 Number of resources for service ibm_database_mongo: 1
    2023/12/05 14:41:47 Refreshing state... ibm_database.tfer--icn_mrwqma_mongo
    2023/12/05 14:41:53 Filtered number of resources for service ibm_database_mongo: 1
    2023/12/05 14:41:53 ibm Connecting....
    2023/12/05 14:41:53 ibm save ibm_database_mongo
    2023/12/05 14:41:53 ibm save tfstate for ibm_database_mongo
    ```
