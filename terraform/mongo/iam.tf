
# Authorization policy between Mongo and Key Protect
# Require to encrypt Mongo DB with Key in Key Protect
resource "ibm_iam_authorization_policy" "mongo-kms" {
  source_service_name = "databases-for-mongodb"
  target_service_name = "kms"
  roles               = ["Reader", "Authorization Delegator"]
}
