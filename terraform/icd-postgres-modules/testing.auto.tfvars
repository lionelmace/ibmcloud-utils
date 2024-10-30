##############################################################################
## Global Variables
##############################################################################

#region                = "eu-de" # eu-de for Frankfurt MZR


##############################################################################
## ICD Postgres
##############################################################################
# Available Plans: standard, enterprise
icd_pg_plan = "standard"
# expected length in the range (10 - 32) - must not contain special characters
icd_pg_admin_pass     = "AdministratorPassw0rd01"
icd_pg_version        = "16"
icd_pg_service_endpoints = "private"
# VPE can only be used if Mongo Private endpoint is enabled
icd_pg_use_vpe = "true"

# Minimum parameter for Enterprise Edition
# icd_postgres_ram_allocation = 14336
# icd_postgres_disk_allocation = 20480
# icd_postgres_core_allocation = 6

# Minimum parameter for Standard Edition
icd_pg_ram_allocation  = 4096
icd_pg_disk_allocation = 5120
icd_pg_core_allocation = 2

icd_pg_users = [{
  name     = "user123"
  password = "password12"
}]
