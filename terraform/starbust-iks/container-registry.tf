resource "ibm_cr_namespace" "container-registry-namespace" {
  name              = format("%s-%s", var.prefix, "registry")
  resource_group_id = ibm_resource_group.resource_group.id
  tags              = var.tags
}