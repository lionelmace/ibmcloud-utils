provider "ibm" {
  region = "eu-de"
}

terraform {
	required_providers {
		ibm = {
	    version = "~> 1.60.0"
		}
  }
}
