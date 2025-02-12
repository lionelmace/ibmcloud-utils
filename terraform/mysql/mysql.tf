##############################################################################
## ICD MySQL
##############################################################################
resource "ibm_database" "icd_mysql" {
  name              = "${var.prefix}-mysql"
  plan              = var.icd_mysql_plan
  location          = var.region
  version           = var.icd_mysql_db_version
  service           = "databases-for-mysql"
  resource_group_id = ibm_resource_group.resource_group.id
  tags              = var.tags

  # Encrypt DB (comment to use IBM-provided Automatic Key)
  key_protect_instance      = ibm_resource_instance.key-protect.id
  key_protect_key           = ibm_kp_key.key.id
  backup_encryption_key_crn = ibm_kp_key.key.id
  depends_on = [ # require when using encryption key otherwise provisioning failed
    ibm_iam_authorization_policy.mysql-kms,
  ]

  # DB Settings
  adminpassword                = var.icd_mysql_adminpassword
  members_memory_allocation_mb = 3072  # 1GB  per member
  members_disk_allocation_mb   = 61440 # 20GB per member
  # users {
  #   name     = "user123"
  #   password = "password12"
  # }
  # whitelist {
  #   address     = "172.168.1.1/32"
  #   description = "desc"
  # }
}
