
##############################################################################
# Create an Activity Tracker instance or reuse an existing one
##############################################################################

variable "activity_tracker_name" {
  description = "Only one instance of Activity Tracker is allowed in a region. If this region already has an instance, enter the name of this instance."
  type        = string
  default     = ""
}

variable "activity_tracker_plan" {
  description = "plan type (14-day, 30-day, 7-day, hipaa-30-day and lite)"
  type        = string
  default     = "30-day"
}

resource "ibm_resource_instance" "activity_tracker" {
  count             = var.activity_tracker_name != "" ? 0 : 1
  name              = format("%s-%s", local.basename, "activity-tracker")
  service           = "logdnaat"
  plan              = var.activity_tracker_plan
  location          = var.region
  resource_group_id = local.resource_group_id
  tags              = var.tags
}

data "ibm_resource_instance" "activity_tracker" {
  count = var.activity_tracker_name != "" ? 1 : 0
  name  = var.activity_tracker_name
}

locals {
  activity_tracker_id = var.activity_tracker_name != "" ? data.ibm_resource_instance.activity_tracker.0.id : ibm_resource_instance.activity_tracker.0.id
}

output "activity_tracker_id" {
  value = local.activity_tracker_id
}


