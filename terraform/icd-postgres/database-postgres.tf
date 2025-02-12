
# Variables
##############################################################################
variable "icd_postgres_plan" {
  type        = string
  description = "The plan type of the Database instance"
  default     = "standard"
}

variable "icd_postgres_adminpassword" {
  type        = string
  description = "The admin user password for the instance"
  default     = "AdminPassw0rd01"
}

variable "icd_postgres_ram_allocation" {
  type        = number
  description = "RAM (GB/data member)"
  default     = 4096
}

variable "icd_postgres_disk_allocation" {
  type        = number
  description = "Disk Usage (GB/data member)"
  default     = 5120
}

variable "icd_postgres_core_allocation" {
  type        = number
  description = "Dedicated Cores (cores/data member)"
  default     = 2
}

variable "icd_postgres_db_version" {
  type        = string
  description = "The database version to provision if specified"
  default     = "16"
}

variable "icd_postgres_users" {
  default     = null
  type        = set(map(string))
  description = "Database Users. It is set of username and passwords"
}

# PostgresDB cannot support both public and private endpoints simultaneously.
# This cannot be changed after provisioning.
variable "icd_postgres_service_endpoints" {
  default     = "public"
  type        = string
  description = "Types of the service endpoints. Possible values are 'public', 'private', 'public-and-private'."
}

variable "icd_postgres_use_vpe" { default = false }


##############################################################################
## ICD Postgres
##############################################################################
resource "ibm_database" "icd_postgres" {
  name              = format("%s-%s", local.basename, "postgres")
  service           = "databases-for-postgresql"
  plan              = var.icd_postgres_plan
  version           = var.icd_postgres_db_version
  service_endpoints = var.icd_postgres_service_endpoints
  location          = var.region
  resource_group_id = ibm_resource_group.group.id
  tags              = var.tags

  # Encrypt DB (comment to use IBM-provided Automatic Key)
  # key_protect_instance      = ibm_resource_instance.key-protect.id
  # key_protect_key           = ibm_kms_key.key.id
  # backup_encryption_key_crn = ibm_kms_key.key.id
  # depends_on = [ # require when using encryption key otherwise provisioning failed
  #   ibm_iam_authorization_policy.postgres-kms,
  # ]

  # DB Settings
  adminpassword = var.icd_postgres_adminpassword
  group {
    group_id = "member"
    # New flag for the new Hosting Model
    host_flavor { id = "multitenant" }
    memory { allocation_mb = var.icd_postgres_ram_allocation }
    disk { allocation_mb = var.icd_postgres_disk_allocation }
    cpu { allocation_count = var.icd_postgres_core_allocation }
  }

  # auto_scaling {
  #   cpu {
  #     rate_increase_percent       = 20
  #     rate_limit_count_per_member = 20
  #     rate_period_seconds         = 900
  #     rate_units                  = "count"
  #   }
  #   disk {
  #     capacity_enabled             = true
  #     free_space_less_than_percent = 15
  #     io_above_percent             = 85
  #     io_enabled                   = true
  #     io_over_period               = "15m"
  #     rate_increase_percent        = 15
  #     rate_limit_mb_per_member     = 3670016
  #     rate_period_seconds          = 900
  #     rate_units                   = "mb"
  #   }
  #   memory {
  #     io_above_percent         = 90
  #     io_enabled               = true
  #     io_over_period           = "15m"
  #     rate_increase_percent    = 10
  #     rate_limit_mb_per_member = 114688
  #     rate_period_seconds      = 900
  #     rate_units               = "mb"
  #   }
  # }

  # users {
  #   name     = "user123"
  #   password = "password12"
  # }

}

## Service Credentials
##############################################################################
resource "ibm_resource_key" "db-svc-credentials" {
  name                 = format("%s-%s", local.basename, "postgres-key")
  resource_instance_id = ibm_database.icd_postgres.id
  role                 = "Viewer"
}

## IAM
##############################################################################
# Doc at https://cloud.ibm.com/docs/cloud-databases?topic=cloud-databases-iam
resource "ibm_iam_access_group_policy" "iam-postgres" {
  access_group_id = ibm_iam_access_group.accgrp.id
  roles           = ["Editor"]

  resources {
    service           = "databases-for-postgresql"
    resource_group_id = ibm_resource_group.group.id
  }
}

locals {
  endpoints = [
    {
      name        = "postgres",
      crn         = ibm_database.icd_postgres.id
      db-name     = nonsensitive(ibm_resource_key.db-svc-credentials.credentials["connection.postgres.database"])
      db-host     = nonsensitive(ibm_resource_key.db-svc-credentials.credentials["connection.postgres.hosts.0.hostname"])
      db-user     = nonsensitive(ibm_resource_key.db-svc-credentials.credentials["connection.postgres.authentication.username"])
      db-password = nonsensitive(ibm_resource_key.db-svc-credentials.credentials["connection.postgres.authentication.password"])
    }
  ]
}

output "icd-postgres-credentials" {
  value = local.endpoints
}

## VPE (Optional)
##############################################################################
# VPE can only be created once Postgres DB is fully registered in the backend
resource "time_sleep" "wait_for_postgres_initialization" {
  count = tobool(var.icd_postgres_use_vpe) ? 1 : 0

  depends_on = [
    ibm_database.icd_postgres
  ]

  create_duration = "5m"
}

# VPE (Virtual Private Endpoint) for Postgres
##############################################################################
# Make sure your Cloud Databases deployment's private endpoint is enabled
# otherwise you'll face this error: "Service does not support VPE extensions."
##############################################################################
resource "ibm_is_virtual_endpoint_gateway" "vpe_postgres" {
  for_each = { for target in local.endpoints : target.name => target if tobool(var.icd_postgres_use_vpe) }

  name           = "${local.basename}-postgres-vpe"
  resource_group = ibm_resource_group.group.id
  vpc            = ibm_is_vpc.vpc.id

  target {
    crn           = ibm_database.icd_postgres.id
    resource_type = "provider_cloud_service"
  }

  # one Reserved IP for per zone in the VPC
  dynamic "ips" {
    for_each = { for subnet in ibm_is_subnet.subnet : subnet.id => subnet }
    content {
      subnet = ips.key
      name   = "${ips.value.name}-ip-postgres"
    }
  }

  depends_on = [
    time_sleep.wait_for_postgres_initialization
  ]

  tags = var.tags
}

# data "ibm_is_virtual_endpoint_gateway_ips" "postgres_vpe_ips" {
#   gateway = ibm_is_virtual_endpoint_gateway.vpe_postgres.id
# }

# output "postgres_vpe_ips" {
#   value = data.ibm_is_virtual_endpoint_gateway_ips.postgres_vpe_ips
# }


# IAM AUTHORIZATIONS
##############################################################################

# Authorization policy between Postgres and Key Protect
# Require to encrypt Postgres DB with Key in Key Protect
# https://github.com/IBM-Cloud/vpc-scaling-dedicated-host/blob/master/modules/create_services/main.tf
resource "ibm_iam_authorization_policy" "postgres-kms" {
  source_service_name         = "databases-for-postgresql"
  target_service_name         = "kms"
  target_resource_instance_id = ibm_resource_instance.key-protect.guid
  roles                       = ["Reader", "Authorization Delegator"]
}