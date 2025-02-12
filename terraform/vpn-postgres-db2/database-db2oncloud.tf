
# Variables
##############################################################################
variable "db2oncloud_plan" {
  type        = string
  description = "The plan type of the Database instance"
  default     = "standard"
}

##############################################################################
## ICD postgresql
##############################################################################
resource "ibm_resource_instance" "db2oncloud" {
  name              = format("%s-%s", local.basename, "db2")
  service           = "dashdb-for-transactions"
  plan              = "enterprise"
  location          = var.region
  resource_group_id = local.resource_group_id
  service_endpoints = "private"
  timeouts {
    create = "30m"
  }
}

## Service Credentials
##############################################################################
## Service Credentials
##############################################################################
resource "ibm_resource_key" "db2oncloud-key" {
  name                 = format("%s-%s", local.basename, "db2-key")
  resource_instance_id = ibm_resource_instance.db2oncloud.id
  role                 = "Viewer"
}

locals {
  db2_endpoints = [
    {
      name    = "db2",
      db-host = nonsensitive(ibm_resource_key.db2oncloud-key.credentials["connection.db2.hosts.0.hostname"])
    }
  ]
}

output "db2-credentials" {
  value = local.db2_endpoints
}