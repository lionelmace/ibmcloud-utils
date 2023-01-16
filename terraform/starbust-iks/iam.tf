# AUTHORIZATIONS

# Authorization policy between DBaaS and Key Protect
# Require to encrypt DBaaS with Key in Key Protect
# https://github.com/IBM-Cloud/vpc-scaling-dedicated-host/blob/master/modules/create_services/main.tf
resource "ibm_iam_authorization_policy" "posgresql-kms" {
  source_service_name         = "databases-for-postgresql"
  target_service_name         = "kms"
  target_resource_instance_id = ibm_resource_instance.key-protect.guid
  roles                       = ["Reader", "Authorization Delegator"]
}