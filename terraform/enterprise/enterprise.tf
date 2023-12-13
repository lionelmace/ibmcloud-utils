# Top level Enterprise Account with label "Enterprise" in the Console
# Failing: Unable to find it...
# data "ibm_enterprises" "top-enterprise" {
#   name = "enterprise-account"
# }

# output "top-enterprise-crn" {
#   value = data.ibm_enterprises.top-enterprise.enterprises.0.crn
# }

# Enterprise Account where resources can be provisioned.
data "ibm_enterprise_accounts" "enterprise-account" {
  name = "enterprise-account"
}

output "enterprise-account-crn" {
  value = data.ibm_enterprise_accounts.enterprise-account.accounts.0.crn
}

output "is_enterprise_account" {
  value = data.ibm_enterprise_accounts.enterprise-account.accounts.0.is_enterprise_account
}

data "ibm_enterprise_account_groups" "enterprise_country_ch" {
  name = "Country Switzerland" // My existing account group
}

resource "ibm_enterprise_account" "coreit" {
  name         = "CoreIT2"
  parent       = data.ibm_enterprise_account_groups.enterprise_country_ch.account_groups.0.crn
  owner_iam_id = data.ibm_enterprise_account_groups.enterprise_country_ch.account_groups.0.primary_contact_iam_id
  traits {
    enterprise_iam_managed = true
  }
}

# resource "ibm_enterprise_account" "child_account" {
#   # parent = data.ibm_enterprise_accounts.accounts.accounts.0.crn // Failed
#   name = "new-child-tf-account"
#   owner_iam_id = "first.last@fr.ibm.com"
# }
