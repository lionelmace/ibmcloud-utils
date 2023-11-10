
variable "vpc_name" {
  type        = string
  default     = ""
  description = "Name of VPC"
}

##############################################################################

data "ibm_is_vpc" "vpc" {
  name = var.vpc_name
}