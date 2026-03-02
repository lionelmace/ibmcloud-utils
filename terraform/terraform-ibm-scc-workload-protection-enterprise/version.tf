terraform {
  required_version = ">= 1.9.0"
  required_providers {
    ibm = {
      source  = "ibm-cloud/ibm"
      version = ">= 1.86.0, < 2.0.0"
    }
    restapi = {
      source  = "Mastercard/restapi"
      version = ">=2.0.1, <3.0.0"
    }
    sysdig = {
      source  = "sysdiglabs/sysdig"
      version = ">= 3.3.1, <4.0.0"
    }
  }
}