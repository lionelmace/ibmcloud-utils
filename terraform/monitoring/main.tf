##############################################################################
# Create a monitoring instance
##############################################################################

resource "ibm_resource_instance" "monitoring_instance" {
  name     = "eid-monitoring"
  service  = "sysdig-monitor"
  plan     = "graduated-tier"
  location = var.region
  # resource_group_id = var.resource_groups[ibm_resource_group.group.id]
  resource_group_id = ibm_resource_group.group.id
  parameters = {
    default_receiver = false
  }
}

resource "ibm_resource_key" "monitoring_key" {
  # count = var.monitoring.key_name != null ? 1 : 0

  name                 = "eid-monitoring-key"
  role                 = "Manager"
  resource_instance_id = ibm_resource_instance.monitoring_instance.id
}

##############################################################################


