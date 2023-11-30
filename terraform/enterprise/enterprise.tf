# Top level Enterprise Account with label "Enterprise" in the Console
# data "ibm_enterprises" "enterprise" {
#     name = "enterprise-account"
# }

# output "enterprise-crn" {
#   value = data.ibm_enterprises.enterprise.enterprises.0.crn
# }

# Enterprise account where resources can be provisioned.
data "ibm_enterprise_accounts" "accounts" {
    name = "enterprise-account"
}

output "enterprise-account-crn" {
  value = data.ibm_enterprise_accounts.accounts.accounts.0.crn
}
# enterprise-account-crn = "crn:v1:bluemix:public:enterprise::a/82e850d55a814f729c69ab4667d0cdf8::account:82e850d55a814f729c69ab4667d0cdf8"

resource "ibm_enterprise_account" "enterprise_account_instance" {
  parent = data.ibm_enterprise_accounts.accounts.accounts.0.crn
  # parent = "86d12027dc2245559daf98ce3d130998"
  name = "new-child-tf-account"
  owner_iam_id = "lionel.mace@fr.ibm.com"
  traits {
    mfa = "NONE"
    enterprise_iam_managed = true
  }
}