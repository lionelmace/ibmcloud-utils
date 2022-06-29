resource "ibm_resource_instance" "app-id" {
  resource_group_id = ibm_resource_group.resource_group.id
  name              = "${var.prefix}-app-id"
  service           = "appid"
  plan              = "graduated-tier"
  location          = var.region
  tags              = var.tags
}