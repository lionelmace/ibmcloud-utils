resource "ibm_resource_instance" "continuous-delivery" {
  resource_group_id = ibm_resource_group.resource_group.id
  name              = "${var.prefix}-continuous-delivery"
  service           = "continuous-delivery"
  plan              = "professional"
  location          = var.region
  tags              = var.tags
}