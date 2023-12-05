provider "ibm" {
  region = "us-south"
}

terraform {
	required_providers {
		ibm = {
	    version = "~> 1.60.0"
		}
  }
}
