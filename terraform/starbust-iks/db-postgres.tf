##############################################################################
## ICD DB as a Service
##############################################################################

variable "icd_dbaas_plan" {
  type        = string
  description = "The plan type of the Database instance"
  default     = "standard"
}
variable "icd_dbaas_adminpassword" {
  type        = string
  description = "The admin user password for the instance"
  default     = "Passw0rd01"
}
variable "icd_dbaas_version" {
  default     = "11"
  type        = string
  description = "The database version to provision if specified"
}
variable "icd_dbaas_users" {
  default     = null
  type        = set(map(string))
  description = "Database Users. It is set of username and passwords"
}
variable "icd_dbaas_whitelist" {
  default     = null
  type        = set(map(string))
  description = "Database Whitelist It is set of IP Address and description"
}
variable "icd_dbaas_service_endpoints" {
  default     = "public"
  type        = string
  description = "Types of the service endpoints. Possible values are 'public', 'private', 'public-and-private'."
}

## IAM
##############################################################################
# Doc at https://cloud.ibm.com/docs/cloud-databases?topic=cloud-databases-iam
resource "ibm_iam_access_group_policy" "iam-dbaas" {
  access_group_id = ibm_iam_access_group.accgrp.id
  roles           = ["Editor"]

  resources {
    service           = "databases-for-postgresql"
    resource_group_id = ibm_resource_group.resource_group.id
  }
}

## Resource
##############################################################################
resource "ibm_database" "icd_postgres" {
  name              = format("%s-%s", var.prefix, "postgres")
  service           = "databases-for-postgresql"
  plan              = var.icd_dbaas_plan
  version           = var.icd_dbaas_version
  service_endpoints = var.icd_dbaas_service_endpoints
  location          = var.region
  resource_group_id = ibm_resource_group.resource_group.id
  tags              = var.tags

  # Encrypt DB (comment to use IBM-provided Automatic Key)
  key_protect_instance      = ibm_resource_instance.key-protect.id
  key_protect_key           = ibm_kp_key.key.id
  backup_encryption_key_crn = ibm_kp_key.key.id
  depends_on = [ # require when using encryption key otherwise provisioning failed
    ibm_iam_authorization_policy.posgresql-kms,
  ]

  # DB Settings
  adminpassword = var.icd_dbaas_adminpassword
  group {
    group_id = "member"

    memory {
      allocation_mb = 1024
    }

    disk {
      allocation_mb = 5120
    }

    cpu {
      allocation_count = 0
    }
  }
}
