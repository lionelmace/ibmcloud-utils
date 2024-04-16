# Top level Enterprise Account with label "Enterprise" in the Console
# Failing: Unable to find it...
# data "ibm_enterprises" "top-enterprise" {
#   name = "top-account"
# }

# output "top-enterprise-crn" {
#   value = data.ibm_enterprises.top-enterprise.enterprises.0.crn
# }

# Enterprise Account where resources can be provisioned.
data "ibm_enterprise_accounts" "top-enterprise-account" {
  name = "top-account"
}

output "top-enterprise-account-crn" {
  value = data.ibm_enterprise_accounts.top-enterprise-account.accounts.0.crn
}

output "is_enterprise_account" {
  value = data.ibm_enterprise_accounts.top-enterprise-account.accounts.0.is_enterprise_account
}

data "ibm_enterprise_account_groups" "enterprise_country_ch" {
  name = "Country Switzerland" // My existing account group
}

