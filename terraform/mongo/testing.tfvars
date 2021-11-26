## terraform apply -var-file="testing.tfvars"

##############################################################################
## Global Variables
##############################################################################
#ibmcloud_api_key = ""      # Set the variable export TF_VAR_ibmcloud_api_key=
prefix         = "tf-mongo"
region         = "eu-de" # eu-de for Frankfurt MZR
resource_group = "tf-mongo"
tags           = ["tf", "mongo"]

##############################################################################
## ICD Mongo
##############################################################################
icd_mongo_plan = "standard"
# expected length in the range (10 - 32) - must not contain special characters
icd_mongo_adminpassword = "Passw0rd01"
icd_mongo_db_version    = "4.2"