data "ibm_enterprises" "enterprise" {
    name = "Enterprise Account"
}

resource "ibm_enterprise_account" "enterprise_account" {
  parent = data.ibm_enterprises.enterprise.id
  name = "new-child-tf-account"
  owner_iam_id = data.ibm_enterprises.enterprise.owner_iam_id
  traits {
    mfa = "NONE"
    enterprise_iam_managed = true
  }
}