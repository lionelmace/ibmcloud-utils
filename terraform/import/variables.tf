variable "ibmcloud_api_key" {
  type = string
}

variable "region" {
  type        = string
  default     = "eu-de"
  description = "Region where to deploy the resources"
}