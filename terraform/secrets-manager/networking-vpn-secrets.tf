
# variable "existing_secrets_manager_guid" {
#   description = "GUID of an existing Secrets Manager instance located in the same region"
#   type        = string
#   default     = ""
# }

resource "ibm_sm_secret_group" "secret_group" {
  # instance_id = var.existing_secrets_manager_guid
  instance_id = local.secrets_manager_guid
  name        = "${local.basename}-vpn-group"
  region      = var.region
  description = "Created by terraform as part of the client VPN example."
}


