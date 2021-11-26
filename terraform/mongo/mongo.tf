##############################################################################
## ICD Mongo
##############################################################################
module "database_mongo" {
  source = "terraform-ibm-modules/database/ibm//modules/mongo"

  resource_group_id     = ibm_resource_group.resource_group.id
  service_name          = "${var.prefix}-mongo"
  plan                  = var.icd_mongo_plan
  location              = var.region
  adminpassword         = var.icd_mongo_adminpassword
  database_version      = var.icd_mongo_db_version
  tags                  = var.tags
  kms_instance          = ibm_resource_instance.kp_instance.id
  disk_encryption_key   = ibm_kp_key.my_kp_key.id
  backup_encryption_key = ibm_kp_key.my_kp_key.id
  depends_on = [ # require when using encryption key otherwise provisioning failed
    ibm_iam_authorization_policy.mongo-kms,
  ]
}