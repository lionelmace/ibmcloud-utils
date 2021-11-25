##############################################################################
## Key Protect
##############################################################################
resource "ibm_resource_instance" "kp_instance" {
  resource_group_id = ibm_resource_group.resource_group.id
  name              = "${var.prefix}-key-protect"
  service           = "kms"
  plan              = "tiered-pricing"
  location          = var.region
  tags              = var.tags
}

resource "ibm_kp_key" "my_kp_key" {
  key_protect_id = ibm_resource_instance.kp_instance.guid
  key_name       = "${var.prefix}-encryption-key"
  standard_key   = false
}