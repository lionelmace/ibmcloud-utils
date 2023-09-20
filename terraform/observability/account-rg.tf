
##############################################################################
# Create a resource group or reuse an existing one
##############################################################################

resource "ibm_resource_group" "group" {
  name = "${local.basename}-group"
  tags = var.tags
}

output "resource_group_name" {
  value = ibm_resource_group.group.name
}