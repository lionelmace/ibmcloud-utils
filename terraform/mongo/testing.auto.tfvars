##############################################################################
## Global Variables
##############################################################################

#region                = "eu-de" # eu-de for Frankfurt MZR

##############################################################################
## VPC
##############################################################################
vpc_classic_access            = false
vpc_address_prefix_management = "manual"
vpc_enable_public_gateway     = true


##############################################################################
## ICD Mongo
##############################################################################
# Available Plans: standard, enterprise
icd_mongo_plan = "standard"
# expected length in the range (10 - 32) - must not contain special characters
icd_mongo_adminpassword     = "Passw0rd01"
icd_mongo_db_version        = "5.0"
icd_mongo_service_endpoints = "private"

# Minimum parameter for Enterprise Edition
# icd_mongo_ram_allocation = 14336
# icd_mongo_disk_allocation = 20480
# icd_mongo_core_allocation = 6

# Minimum parameter for Standard Edition
icd_mongo_ram_allocation  = 1024
icd_mongo_disk_allocation = 20480
icd_mongo_core_allocation = 0

icd_mongo_users = [{
  name     = "user123"
  password = "password12"
}]
