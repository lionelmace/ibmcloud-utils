
# Variables
##############################################################################
variable "icd_pg_plan" {
  type        = string
  description = "The plan type of the Database instance"
  default     = "standard"
}

variable "icd_pg_admin_pass" {
  type        = string
  description = "The admin user password for the instance"
  default     = "AdministratorPassw0rd01"
}

variable "icd_pg_version" {
  type        = string
  description = "The database version to provision if specified"
  default     = "16"
}

variable "icd_pg_users" {
  default     = null
  type        = set(map(string))
  description = "Database Users. It is set of username and passwords"
}

# PostgresDB cannot support both public and private endpoints simultaneously.
# This cannot be changed after provisioning.
variable "icd_pg_service_endpoints" {
  default     = "public"
  type        = string
  description = "Types of the service endpoints. Possible values are 'public', 'private', 'public-and-private'."
}

variable "icd_pg_use_vpe" { default = false }


##############################################################################
## ICD Postgres
##############################################################################

module "postgresql_db" {
  source            = "terraform-ibm-modules/icd-postgresql/ibm"
  version           = "3.17.9"
  resource_group_id = ibm_resource_group.group.id
  name              = format("%s-%s", local.basename, "postgres")
  region            = var.region
  pg_version        = var.icd_pg_version
  admin_pass        = var.icd_pg_admin_pass
  # users                      = var.icd_pg_users
  # kms_encryption_enabled     = true
  # kms_key_crn                = module.key_protect_all_inclusive.keys["icd-key"].crn
  # existing_kms_instance_guid = module.key_protect_all_inclusive.kms_guid
  resource_tags = var.tags
  # service_credential_names   = var.service_credential_names
  # access_tags                = var.access_tags
  member_host_flavor = "b3c.4x16.encrypted"
  # auto_scaling               = var.auto_scaling

  configuration = {
    shared_buffers             = 32000
    max_connections            = 250
    max_locks_per_transaction  = 64
    max_prepared_transactions  = 0
    synchronous_commit         = "local"
    effective_io_concurrency   = 12
    deadlock_timeout           = 10000
    log_connections            = "off"
    log_disconnections         = "off"
    log_min_duration_statement = 100
    tcp_keepalives_idle        = 200
    tcp_keepalives_interval    = 50
    tcp_keepalives_count       = 6
    archive_timeout            = 1000
    wal_level                  = "logical"
    max_replication_slots      = 21
    max_wal_senders            = 21
  }
  # cbr_rules = [
  #   {
  #     description      = "${var.env}-postgres access only from vpc"
  #     enforcement_mode = "enabled"
  #     account_id       = data.ibm_iam_account_settings.iam_account_settings.account_id
  #     rule_contexts = [{
  #       attributes = [
  #         {
  #           "name" : "endpointType",
  #           "value" : "private"
  #         },
  #         {
  #           name  = "networkZoneId"
  #           value = module.cbr_zone.zone_id
  #       }]
  #     }]
  #   }
  # ]
}

