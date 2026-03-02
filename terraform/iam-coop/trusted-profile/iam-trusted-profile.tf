
############################################################################
# Trusted Profile Creation
############################################################################
resource "ibm_iam_trusted_profile" "my_trusted_profile" {
  name = "${var.prefix}-trusted-profile"
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
