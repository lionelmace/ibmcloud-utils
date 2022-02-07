
##############################################################################
# Resource Group where Cloud Resources will be created
##############################################################################

resource "ibm_resource_group" "resource_group" {
  name = var.resource_group
}
