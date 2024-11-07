##############################################################################
## Create a Secrets Manager instance or reuse an existing one
##############################################################################

variable "existing_secrets_manager_name" {
  description = "Only one Trial plan of Secrets Manager is allowed per account. If this account already has an instance, enter the CRN (Cloud Resource Name)."
  type        = string
  default     = ""
}

resource "ibm_resource_instance" "secrets_manager" {
  count             = var.existing_secrets_manager_name != "" ? 0 : 1
  name              = format("%s-%s", local.basename, "secrets-manager")
  service           = "secrets-manager"
  plan              = "trial"
  location          = var.region
  resource_group_id = local.resource_group_id
  tags              = var.tags
  service_endpoints = "private"
}

# resource "ibm_sm_secret_group" "sm_secret_group"{
#   instance_id   = local.secrets_manager_guid
#   region        = var.region
#   name          = format("%s-%s", local.basename, "sm-group")
#   description   = "Secret Group"
# }

data "ibm_resource_instance" "secrets_manager" {
  count = var.existing_secrets_manager_name != "" ? 1 : 0
  name  = var.existing_secrets_manager_name
}

locals {
  secrets_manager_id   = var.existing_secrets_manager_name != "" ? data.ibm_resource_instance.secrets_manager.0.id : ibm_resource_instance.secrets_manager.0.id
  secrets_manager_guid = var.existing_secrets_manager_name != "" ? data.ibm_resource_instance.secrets_manager.0.guid : ibm_resource_instance.secrets_manager.0.guid
}

output "secrets_manager_id" {
  value = local.secrets_manager_id
}