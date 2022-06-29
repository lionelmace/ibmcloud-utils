##############################################################################
# IBM Cloud Provider
# > Remove for use in schematics
##############################################################################

terraform {
  required_version = ">= 1.0.11"
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = "1.42.0"
    }
  }
}

provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.region
  ibmcloud_timeout = 60
}

##############################################################################