##############################################################################
## Secrets Manager
##############################################################################
resource "ibm_resource_instance" "secrets-manager" {
  name              = "${var.prefix}-secrets-manager"
  service           = "secrets-manager"
  plan              = "trial"
  location          = var.region
  resource_group_id = ibm_resource_group.resource_group.id
  tags              = var.tags
  service_endpoints = "private"
}

output "secrets-manager-crn" {
  description = "The CRN of the Secrets Manager instance"
  value       = ibm_resource_instance.secrets-manager.id
}

resource "null_resource" "attach-secrets-manager-to-cluster" {

  triggers = {
    APIKEY             = var.ibmcloud_api_key
    REGION             = var.region
    CLUSTER_ID         = module.vpc_kubernetes_cluster.kubernetes_vpc_cluster_id
    SECRETS_MANAGER_ID = ibm_resource_instance.secrets-manager.id
  }

  provisioner "local-exec" {
    command = "./attach-secrets-manager.sh"
    environment = {
      APIKEY             = self.triggers.APIKEY
      REGION             = self.triggers.REGION
      CLUSTER_ID         = self.triggers.CLUSTER_ID
      SECRETS_MANAGER_ID = self.triggers.SECRETS_MANAGER_ID
    }
  }

  # provisioner "local-exec" {
  #   when    = destroy
  #   command = "./secrets-destroy.sh"
  #   environment = {
  #     APIKEY             = self.triggers.APIKEY
  #     REGION             = self.triggers.REGION
  #     SECRETS_MANAGER_ID = self.triggers.SECRETS_MANAGER_ID
  #   }
  # }
}