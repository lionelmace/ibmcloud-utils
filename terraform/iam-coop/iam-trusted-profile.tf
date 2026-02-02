data "ibm_iam_account_settings" "me" {}

output "terraform_account_id" {
  value = data.ibm_iam_account_settings.me.account_id
}

data "ibm_iam_service_id" "non_prod_service_id" {
  name = "tbd-mace-service-id"
}

output "service_id_lookup_id" {
  value = data.ibm_iam_service_id.non_prod_service_id.id
}

############################################################################
# Trusted Profile Creation
############################################################################
resource "ibm_iam_trusted_profile" "my_trusted_profile" {
  name = "my-trusted-profile"
}

resource "ibm_iam_trusted_profile_policy" "admin_trusted_profile" {
  iam_id  = ibm_iam_trusted_profile.my_trusted_profile.iam_id
  roles       = ["Administrator"]
  description = "Administrator Trusted Profile Policy"

  resource_attributes {
    name     = "serviceType"
    operator = "stringEquals"
    value    = "platform_service"
  }
}
