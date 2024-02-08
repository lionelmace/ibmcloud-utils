
# Variables
##############################################################################
variable "icd_postgresql_plan" {
  type        = string
  description = "The plan type of the Database instance"
  default     = "standard"
}

variable "icd_postgresql_adminpassword" {
  type        = string
  description = "The admin user password for the instance"
  default     = "AdministratorPassw0rd01"
}

variable "icd_postgresql_ram_allocation" {
  type        = number
  description = "RAM (GB/data member)"
  default     = 1024
}

variable "icd_postgresql_disk_allocation" {
  type        = number
  description = "Disk Usage (GB/data member)"
  default     = 20480
}

variable "icd_postgresql_core_allocation" {
  type        = number
  description = "Dedicated Cores (cores/data member)"
  default     = 0
}

variable "icd_postgresql_db_version" {
  type        = string
  description = "The database version to provision if specified"
  default     = "15"
}

variable "icd_postgresql_users" {
  default     = null
  type        = set(map(string))
  description = "Database Users. It is set of username and passwords"
}

# postgresqlDB cannot support both public and private endpoints simultaneously.
# This cannot be changed after provisioning.
variable "icd_postgresql_service_endpoints" {
  default     = "private"
  type        = string
  description = "Types of the service endpoints. Possible values are 'public', 'private', 'public-and-private'."
}

variable "icd_postgresql_use_vpe" { default = false }


##############################################################################
## ICD postgresql
##############################################################################
resource "ibm_database" "icd_postgresql" {
  name              = format("%s-%s", local.basename, "postgresql")
  service           = "databases-for-postgresql"
  plan              = var.icd_postgresql_plan
  version           = var.icd_postgresql_db_version
  service_endpoints = var.icd_postgresql_service_endpoints
  location          = var.region
  resource_group_id = ibm_resource_group.group.id
  tags              = var.tags

  # Encrypt DB (comment to use IBM-provided Automatic Key)
  # key_protect_instance = ibm_resource_instance.key-protect.id
  # key_protect_key      = ibm_kms_key.key.id
  # backup_encryption_key_crn = ibm_kms_key.key.id
  # depends_on = [ # require when using encryption key otherwise provisioning failed
  #   ibm_iam_authorization_policy.postgresql-kms,
  # ]

  # DB Settings
  adminpassword = var.icd_postgresql_adminpassword
  group {
    group_id = "member"
    memory { allocation_mb = var.icd_postgresql_ram_allocation }
    disk { allocation_mb = var.icd_postgresql_disk_allocation }
    cpu { allocation_count = var.icd_postgresql_core_allocation }
  }

  # users {
  #   name     = "user123"
  #   password = "password12"
  # }

}

## Service Credentials
##############################################################################
resource "ibm_resource_key" "icd_postgresql_key" {
  name                 = format("%s-%s", local.basename, "postgresql-key")
  resource_instance_id = ibm_database.icd_postgresql.id
  role                 = "Viewer"
}

# Database connection
##############################################################################
# data "ibm_database_connection" "postgresql_db_connection" {
#     deployment_id = ibm_database.icd_postgresql.id
#     endpoint_type = var.icd_postgresql_service_endpoints
#     user_id = "user_id"
#     user_type = "database"
# }

locals {
  endpoints = [
    {
      name     = "postgresql",
      crn      = ibm_database.icd_postgresql.id
      hostname = ibm_resource_key.icd_postgresql_key.credentials["connection.postgres.hosts.0.hostname"]
    }
  ]
}

output "endpoints" {
  sensitive = true
  value     = local.endpoints
}


## VPE (Optional)
##############################################################################
# VPE can only be created once postgresql DB is fully registered in the backend
resource "time_sleep" "wait_for_postgresql_initialization" {
  count = tobool(var.icd_postgresql_use_vpe) ? 1 : 0

  depends_on = [
    ibm_database.icd_postgresql
  ]

  create_duration = "5m"
}

# VPE (Virtual Private Endpoint) for postgresql
##############################################################################
# Make sure your Cloud Databases deployment's private endpoint is enabled
# otherwise you'll face this error: "Service does not support VPE extensions."
##############################################################################
resource "ibm_is_virtual_endpoint_gateway" "vpe_postgresql" {
  for_each = { for target in local.endpoints : target.name => target if tobool(var.icd_postgresql_use_vpe) }

  name           = "${local.basename}-postgresql-vpe"
  resource_group = ibm_resource_group.group.id
  vpc            = ibm_is_vpc.vpc.id

  target {
    crn           = ibm_database.icd_postgresql.id
    resource_type = "provider_cloud_service"
  }

  # one Reserved IP for per zone in the VPC
  dynamic "ips" {
    for_each = { for subnet in ibm_is_subnet.subnet : subnet.id => subnet }
    content {
      subnet = ips.key
      name   = "${ips.value.name}-ip"
    }
  }

  depends_on = [
    time_sleep.wait_for_postgresql_initialization
  ]

  tags = var.tags
}

# AUTHORIZATIONS
##############################################################################

# Authorization policy between postgresql and Key Protect
# Require to encrypt postgresql DB with Key in Key Protect
# https://github.com/IBM-Cloud/vpc-scaling-dedicated-host/blob/master/modules/create_services/main.tf
# resource "ibm_iam_authorization_policy" "postgresql-kms" {
#   source_service_name         = "databases-for-postgresqldb"
#   target_service_name         = "kms"
#   target_resource_instance_id = ibm_resource_instance.key-protect.guid
#   roles                       = ["Reader", "Authorization Delegator"]
# }