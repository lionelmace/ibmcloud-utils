
# Authorization policy between Mongo and Key Protect
# Require to encrypt Mongo DB with Key in Key Protect
resource "ibm_iam_authorization_policy" "mongo-kms" {
  source_service_name = "databases-for-mongodb"
  target_service_name = "kms"
  target_resource_instance_id = ibm_resource_instance.key-protect.guid
  roles               = ["Reader", "Authorization Delegator"]
}