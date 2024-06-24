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
## ICD Postgres
##############################################################################
# Available Plans: standard, enterprise
icd_postgres_plan = "standard"
# expected length in the range (10 - 32) - must not contain special characters
icd_postgres_adminpassword     = "AdministratorPassw0rd01"
icd_postgres_db_version        = "16"
icd_postgres_service_endpoints = "private"
# VPE can only be used if Mongo Private endpoint is enabled
icd_postgres_use_vpe           = "true"

# Minimum parameter for Enterprise Edition
# icd_postgres_ram_allocation = 14336
# icd_postgres_disk_allocation = 20480
# icd_postgres_core_allocation = 6

# Minimum parameter for Standard Edition
icd_postgres_ram_allocation  = 1024
icd_postgres_disk_allocation = 20480
icd_postgres_core_allocation = 0

icd_postgres_users = [{
  name     = "user123"
  password = "password12"
}]
