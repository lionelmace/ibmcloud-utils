#!/bin/sh

## Script to create access groups for Administrator
## 1. All account management services
## 2. All resources in account (including future IAM enabled services)
## 3. All User Management resources
## -------------------------------------------------------------------

## Resource Group
RG="client"

## Define Access Group name and description
AG_NAME="group-admin-test"
AG_DESCRIPTION="GroupAdministrator"

## Create Access Group
ibmcloud iam access-group-create $AG_NAME -d $AG_DESCRIPTION

## Assing Access Group Policies
echo "Assigning policies to Access Group $AG_NAME"

# Add Policy: All account management services
ibmcloud iam access-group-policy-create $AG_NAME --roles Administrator --account-management

# Add Policy: All resources in account (including future IAM enabled services)
# ibmcloud iam access-group-policy-create $AG_NAME --roles Administrator,Manager --service-type service

# Add Policy: All User Management resources
# ibmcloud iam access-group-policy-create $AG_NAME --roles Administrator --service-name user-management 

## Give Access with a Resource Group
# ibmcloud iam access-group-policy-create $AG_NAME --roles Viewer --resource-group-name $RG
# ibmcloud iam access-group-policy-create $AG_NAME --roles Administrator --resource-type resource-group --resource $RG

## Add User to the Access Group
# ibmcloud iam access-group-user-add $AG_NAME first.lastname@company.com
# ibmcloud iam access-group-user-add $AG_NAME first.lastname@company.com first2.last2@company.com
