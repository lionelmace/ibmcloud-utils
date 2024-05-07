##############################################################################
# IBM Cloud Provider
##############################################################################

terraform {
  required_version = ">=1.5"
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = "1.65.0"
    }
    logdna = {
      source  = "logdna/logdna"
      version = ">= 1.16.0"
    }
  }
}

provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.region
}

##############################################################################