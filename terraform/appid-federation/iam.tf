
# Authorization policy between MySQL and Key Protect
# resource "ibm_iam_authorization_policy" "mysql-kms" {
#   source_service_name = "databases-for-mysql"
#   target_service_name = "kms"
#   roles               = ["Reader", "Authorization Delegator"]
# }
