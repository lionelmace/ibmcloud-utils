##############################################################################
# IBM Cloud Provider
##############################################################################

terraform {
  required_version = ">=1.6"
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = "1.69.0"
    }
    logdna = {
      source  = "logdna/logdna"
      version = ">= 1.14.2"
    }
    http-full = {
      source = "salrashid123/http-full"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.4"
    }
  }
}

provider "http-full" {}

provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.region
}

##############################################################################