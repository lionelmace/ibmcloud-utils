# data "ibm_enterprises" "enterprise" {
#     name = "enterprise-account"
# }

data "ibm_enterprise_accounts" "accounts" {
    name = "enterprise-account"
}

resource "ibm_enterprise_account" "enterprise_account_instance" {
  parent = data.ibm_enterprise_accounts.accounts.0.crn
  name = "new-child-tf-account"
  owner_iam_id = "lionel.mace@fr.ibm.com"
  traits {
    mfa = "NONE"
    enterprise_iam_managed = true
  }
}