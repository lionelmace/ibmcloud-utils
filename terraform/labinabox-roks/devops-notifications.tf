resource "ibm_resource_instance" "event-notifications" {
  name              = format("%s-%s", local.basename, "event-notifications")
  service           = "event-notifications"
  plan              = "lite"
  location          = var.region
  resource_group_id = local.resource_group_id
}