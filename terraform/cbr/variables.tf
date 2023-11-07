variable "ibmcloud_api_key" {
  type = string
}

variable "region" {
  type        = string
  default     = "eu-de"
  description = "Region where to deploy the resources"
}

variable "tags" {
  description = "List of Tags"
  type        = list(string)
  default     = ["tf", "training"]
}

variable "prefix" {
  type        = string
  default     = ""
  description = "A prefix for all resources to be created. If none provided a random prefix will be created"
}

resource "random_string" "random" {
  count = var.prefix == "" ? 1 : 0

  length  = 6
  special = false
}

locals {
  basename = lower(var.prefix == "" ? "cbr-${random_string.random.0.result}" : var.prefix)
}

variable "ssh_public_key" {
  description = "SSH Public Key. Get your ssh key by running `ssh-key-gen` command"
  type        = string
  default     = null
}

variable "ssh_key_id" {
  description = "ID of SSH public key stored in IBM Cloud"
  type        = string
  default     = null
}

variable "create_public_ip" {
  type    = bool
  default = true
}

variable "image_name" {
  type        = string
  default     = "ibm-ubuntu-18-04-1-minimal-amd64-2"
  description = "Name of the image to use for the private instance"
}

variable "profile_name" {
  type        = string
  description = "Instance profile to use for the private instance"
  default     = "cx2-2x4"
  # default     = "bx2-2x8"
}

# Account ID is required for CBR (Context Based Restrictions)
#############################################################
data "ibm_iam_auth_token" "tokendata" {}
data "ibm_iam_account_settings" "account_settings" {}

locals {
  account_id = data.ibm_iam_account_settings.account_settings.account_id
}