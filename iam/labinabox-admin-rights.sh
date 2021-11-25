#!/bin/sh

## Script to create an Access Group (AG) for an existing Resource Group (RG)
## 1. xx
## 2. xx
## 3. xx

EMAIL=first.last@company.com

## Resource Group Name
RG="lab"

## Access Group name and description
AG_NAME="ag-labinbox"
AG_DESCRIPTION="For all admin of Lab in a Box"

## Create Access Group
# ibmcloud iam access-group-create $AG_NAME -d $AG_DESCRIPTION

## Assign Policy
## -------------

# Role Management to be able to create Resource Group (Bub not sufficient to create a Resource Group... not sure why)
ibmcloud iam access-group-policy-create $AG_NAME --roles Editor --service-name iam-access-management

# Account Management Services required for Lab in a Box
# Console Name: "All account management services"
#ibmcloud iam access-group-policy-create $AG_NAME --roles Editor --resource-type platform_service ????
# Console Name: "Identity and Access Management service"
ibmcloud iam access-group-policy-create $AG_NAME --roles Administrator --service-name iam-svcs 

# Connect to Cloud Foundry
CF_ORG=rh-france
CF_SPACE=dev
ibmcloud target --cf-api https://api.eu-de.cf.cloud.ibm.com
# -o $CF_ORG -s $CF_SPACE
ibmcloud account org-user-add $EMAIL $CF_ORG
ibmcloud cf set-space-role $EMAIL $CF_ORG $CF_SPACE SpaceDeveloper
# above throws error: FAILED Server error, status code: 503, error code: 20004, message: The UAA service is currently unavailable

## Give Access with a Resource Group
## ---------------------------------
# ibmcloud iam access-group-policy-create $AG_NAME --roles Viewer --resource-type resource-group --resource $RG

## Add User to the Access Group
## ----------------------------
# ibmcloud iam access-group-user-add $AG_NAME first.last@company.com
# ibmcloud iam access-group-user-add $AG_NAME first.last@company.com first2.last2@company.com