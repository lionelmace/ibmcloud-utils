
##############################################################################
# Create a resource group or reuse an existing one
##############################################################################

resource "ibm_resource_group" "group" {
  name = "test-group"
  tags = var.tags
}

output "resource_group_name" {
  value = ibm_resource_group.group.name
}

resource "ibm_resource_group" "rg-vmware-lab" {
  name = "vmware-lab"
  tags = var.tags
}
