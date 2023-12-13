# Top level Enterprise Account with label "Enterprise" in the Console
data "ibm_enterprises" "top-enterprise" {
    # name = "enterprise-account"
}

output "top-enterprise-crn" {
  value = data.ibm_enterprises.top-enterprise.enterprises.0.crn
}

# Enterprise account where resources can be provisioned.
data "ibm_enterprise_accounts" "enterprise-account" {
    name = "enterprise-account"
}

output "enterprise-account-crn" {
  value = data.ibm_enterprise_accounts.enterprise-account.accounts.0.crn
}

output "is_enterprise_account" {
  value = data.ibm_enterprise_accounts.enterprise-account.accounts.0.is_enterprise_account
}

# resource "ibm_enterprise_account" "child_account" {
#   parent = data.ibm_enterprise_accounts.accounts.accounts.0.crn
#   # parent = "86d12027dc2245559daf98ce3d130998"
#   name = "new-child-tf-account"
#   owner_iam_id = "first.last@fr.ibm.com"
#   # Optional:
#   # traits {
#   #   mfa = "NONE"
#   #   enterprise_iam_managed = true
#   # }
# }
