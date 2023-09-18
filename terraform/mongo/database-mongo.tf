
# Variables
##############################################################################
variable "icd_mongo_plan" {
  type        = string
  description = "The plan type of the Database instance"
  default     = "standard"
}

variable "icd_mongo_adminpassword" {
  type        = string
  description = "The admin user password for the instance"
  default     = "Passw0rd01"
}

variable "icd_mongo_ram_allocation" {
  type        = number
  description = "RAM (GB/data member)"
  default     = 1024
}

variable "icd_mongo_disk_allocation" {
  type        = number
  description = "Disk Usage (GB/data member)"
  default     = 20480
}

variable "icd_mongo_core_allocation" {
  type        = number
  description = "Dedicated Cores (cores/data member)"
  default     = 0
}

variable "icd_mongo_db_version" {
  type        = string
  description = "The database version to provision if specified"
  default     = "5.0"
}

variable "icd_mongo_users" {
  default     = null
  type        = set(map(string))
  description = "Database Users. It is set of username and passwords"
}

# MongoDB cannot support both public and private endpoints simultaneously.
# This cannot be changed after provisioning.
variable "icd_mongo_service_endpoints" {
  default     = "public"
  type        = string
  description = "Types of the service endpoints. Possible values are 'public', 'private', 'public-and-private'."
}

variable "icd_mongo_use_vpe" { default = false }


##############################################################################
## ICD Mongo
##############################################################################
resource "ibm_database" "icd_mongo" {
  name              = format("%s-%s", local.basename, "mongo")
  service           = "databases-for-mongodb"
  plan              = var.icd_mongo_plan
  version           = var.icd_mongo_db_version
  service_endpoints = var.icd_mongo_service_endpoints
  location          = var.region
  resource_group_id = ibm_resource_group.group.id
  tags              = var.tags

  # Encrypt DB (comment to use IBM-provided Automatic Key)
  key_protect_instance = ibm_resource_instance.key-protect.id
  key_protect_key      = ibm_kms_key.key.id
  # BYOK for backups available only in us-south, us-east, and eu-de (June 2023)
  # backup_encryption_key_crn = ibm_kms_key.key.id
  depends_on = [ # require when using encryption key otherwise provisioning failed
    ibm_iam_authorization_policy.mongo-kms,
  ]

  # DB Settings
  adminpassword = var.icd_mongo_adminpassword
  group {
    group_id = "member"
    memory { allocation_mb = var.icd_mongo_ram_allocation }
    disk { allocation_mb = var.icd_mongo_disk_allocation }
    cpu { allocation_count = var.icd_mongo_core_allocation }
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
resource "ibm_resource_key" "icd_mongo_key" {
  name                 = format("%s-%s", local.basename, "mongo-key")
  resource_instance_id = ibm_database.icd_mongo.id
  role                 = "Viewer"
}

# Database connection
##############################################################################
# data "ibm_database_connection" "mongo_db_connection" {
#     deployment_id = ibm_database.icd_mongo.id
#     endpoint_type = var.icd_mongo_service_endpoints
#     user_id = "user_id"
#     user_type = "database"
# }

# output "iks_cluster_alb" {
#   value = data.ibm_database_connection.mongo_db_connection.database
# }


## IAM
##############################################################################
# Doc at https://cloud.ibm.com/docs/cloud-databases?topic=cloud-databases-iam
resource "ibm_iam_access_group_policy" "iam-mongo" {
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
      name     = "redis",
      crn      = ibm_database.icd_mongo.id
      hostname = ibm_resource_key.icd_mongo_key.credentials["connection.mongodb.hosts.0.hostname"]
    }
  ]
}

output "endpoints" {
  sensitive = true
  value     = local.endpoints
}


## VPE (Optional)
##############################################################################
# VPE can only be created once Mongo DB is fully registered in the backend
resource "time_sleep" "wait_for_mongo_initialization" {
  count = tobool(var.icd_mongo_use_vpe) ? 1 : 0

  depends_on = [
    ibm_database.icd_mongo
  ]

  create_duration = "5m"
}

# VPE (Virtual Private Endpoint) for Mongo
##############################################################################
# Make sure your Cloud Databases deployment's private endpoint is enabled
# otherwise you'll face this error: "Service does not support VPE extensions."
##############################################################################
resource "ibm_is_virtual_endpoint_gateway" "vpe_mongo" {
  for_each = { for target in local.endpoints : target.name => target if tobool(var.icd_mongo_use_vpe) }

  name           = "${local.basename}-mongo-vpe"
  resource_group = ibm_resource_group.group.id
  vpc            = ibm_is_vpc.vpc.id

  target {
    crn           = ibm_database.icd_mongo.id
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
    time_sleep.wait_for_mongo_initialization
  ]

  tags = var.tags
}

data "ibm_is_virtual_endpoint_gateway_ips" "mongo_vpe_ips" {
  gateway = ibm_is_virtual_endpoint_gateway.vpe_mongo.id
}

output "mongo_vpe_ips" {
  value = data.ibm_is_virtual_endpoint_gateway_ips.mongo_vpe_ips
}


# AUTHORIZATIONS
##############################################################################

# Authorization policy between Mongo and Key Protect
# Require to encrypt Mongo DB with Key in Key Protect
# https://github.com/IBM-Cloud/vpc-scaling-dedicated-host/blob/master/modules/create_services/main.tf
resource "ibm_iam_authorization_policy" "mongo-kms" {
  source_service_name         = "databases-for-mongodb"
  target_service_name         = "kms"
  target_resource_instance_id = ibm_resource_instance.key-protect.guid
  roles                       = ["Reader", "Authorization Delegator"]
}