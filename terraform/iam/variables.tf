
variable "ibmcloud_api_key" {
  description = "The IBM Cloud platform API key needed to deploy IAM enabled resources"
}

variable "region" {
  description = "IBM Cloud region where all resources will be provisioned"
  default     = ""
}