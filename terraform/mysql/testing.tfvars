## terraform apply -var-file="testing.tfvars"

##############################################################################
## Global Variables
##############################################################################
#ibmcloud_api_key = ""      # Set the variable export TF_VAR_ibmcloud_api_key=
prefix         = "tf"
region         = "ca-tor" # eu-de for Frankfurt MZR
resource_group = "tf-mysql"
tags           = ["tf", "mysql"]

##############################################################################
## ICD MySQL
##############################################################################
icd_mysql_plan = "standard"
# expected length in the range (10 - 32) - must not contain special characters
icd_mysql_adminpassword = "Passw0rd01"
icd_mysql_db_version    = "5.7"