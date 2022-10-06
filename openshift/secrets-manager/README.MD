# Test Secrets Manager as a replacement of Certificate Manager

1. Enable service-to-service communication via Terraform

    ```tf
    resource "ibm_iam_authorization_policy" "iks-sm" {
    source_service_name         = "containers-kubernetes"
    source_resource_instance_id = module.vpc_kubernetes_cluster.kubernetes_vpc_cluster_id
    target_service_name         = "secrets-manager"
    target_resource_instance_id = ibm_resource_instance.secrets-manager.guid
    roles                       = ["Manager"]
    }
    ```

    > [Example](https://github.com/lionelmace/mytodo/blob/master/cloud/terraform/iam.tf#L83)

1. Create a Secrets Manager instance via Terraform

    ```tf
    resource "ibm_resource_instance" "secrets-manager" {
    name              = "${var.prefix}-secrets-manager"
    service           = "secrets-manager"
    plan              = "trial"
    location          = var.region
    resource_group_id = ibm_resource_group.resource_group.id
    tags              = var.tags
    service_endpoints = "private"
    }

    output "sm_instance_crn" {
    description = "The CRN of the Secrets Manager instance"
    value       = ibm_resource_instance.secrets-manager.id
    }
    ```

    > [Example](https://github.com/lionelmace/mytodo/blob/master/cloud/terraform/secrets-manager.tf#L4)

1. Register your Secrets Manager instance to your cluster via terraform

1. Verify that the Secrets Manager instance was registered to the cluster.

    ```sh
    ibmcloud ks ingress instance ls --cluster $CLUSTER_ID
    ```

1. Clone this repository

1. Provision the following infra

    ```sh
    tf plan
    tf apply
    ```

1. xx

## Resources

* [Registering a Secrets Manager instance when creating a cluster](https://cloud.ibm.com/docs/containers?topic=containers-secrets-mgr#secrets-mgr_cluster_create)