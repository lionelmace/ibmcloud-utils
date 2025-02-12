
resource "ibm_resource_instance" "event-streams" {
  name              = format("%s-%s", local.basename, "event-streams")
  service           = "messagehub"
  # Lite plan is not available in Frankfurt Region.
  plan              = "lite"
  location          = "us-south"
  resource_group_id = local.resource_group_id
}

resource "ibm_event_streams_topic" "test" {
  resource_instance_id = ibm_resource_instance.event-streams.id
  name                 = "test"
  partitions           = 1
}