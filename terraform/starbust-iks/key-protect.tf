##############################################################################
## Key Protect
##############################################################################
resource "ibm_resource_instance" "key-protect" {
  resource_group_id = ibm_resource_group.resource_group.id
  name              = format("%s-%s", var.prefix, "key-protect")
  service           = "kms"
  plan              = "tiered-pricing"
  location          = var.region
  tags              = var.tags
  service_endpoints = "private"
}

resource "ibm_kp_key" "key" {
  key_protect_id = ibm_resource_instance.key-protect.guid
  key_name       = "${var.prefix}-root-key"
  standard_key   = false
  force_delete   = true
}

## IAM
##############################################################################
resource "ibm_iam_access_group_policy" "iam-key-protect" {
  access_group_id = ibm_iam_access_group.accgrp.id
  roles           = ["Writer", "Editor"]

  resources {
    service           = "kms"
    resource_group_id = ibm_resource_group.resource_group.id
  }
}