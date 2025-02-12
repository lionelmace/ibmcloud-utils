#ibmcloud_api_key = ""      # Set the variable export TF_VAR_ibmcloud_api_key=
prefix = "multizone"
region = "eu-de" # eu-de for Frankfurt MZR
tags   = ["tf", "multizone"]

vpc_classic_access            = false
vpc_address_prefix_management = "manual"
vpc_enable_public_gateway     = true
# vpc_locations                 = ["eu-de-1", "eu-de-2", "eu-de-3"]
# vpc_number_of_addresses       = 256


