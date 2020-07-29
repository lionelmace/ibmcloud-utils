variable "ibmcloud_api_key" {
  type = "string"
}

variable "plan" {
  default = "30-day"
}

variable "region" {
  default = "eu-de"
}

variable "instance_name" {
  default = "Schematics-Prod-LogDNA-EU-DE"
}

variable "rg_name" {
  default = "schematics-prod"
}

variable "service_name" {
  default = "schematics"
}

variable "provision_key" {
  default = ""
}