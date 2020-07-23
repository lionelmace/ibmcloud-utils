#!/bin/sh

## Script to create an Access Group (AG) for an existing Resource Group (RG)
## 1. xx
## 2. xx
## 3. xx

## Resource Group Name
RG="lab"

## Access Group name and description
AG_NAME="lab-users"
AG_DESCRIPTION="For all users of the lab"

## Create Access Group
# ibmcloud iam access-group-create $AG_NAME -d $AG_DESCRIPTION

## Assign Policy
## -------------

# Cloudant
ibmcloud iam access-group-policy-create $AG_NAME --roles Manager,Editor --service-name cloudantnosqldb $ADD_RG
# ibmcloud iam access-group-policy-create lab-users --roles Manager,Editor --service-name cloudantnosqldb --resource-group-id a260658ac8b14975827b8d6b3d146aea

# Continuous Delivery
ibmcloud iam access-group-policy-create $AG_NAME --roles Editor,Writer --service-name continuous-delivery $ADD_RG
ibmcloud iam access-group-policy-create $AG_NAME --roles Editor --service-name toolchain $ADD_RG

# Container Registry - Allow users to read/write images in the namespace
#ibmcloud iam access-group-policy-create $AG_NAME --roles Manager,Administrator --service-name container-registry $ADD_RG
ibmcloud iam access-group-policy-create $AG_NAME \
  --service-name container-registry \
  --region eu-de \
  --resource-type namespace \
  --resource "lab-registry" \
  --roles Reader,Writer

# Kubernetes Service
#ibmcloud iam access-group-policy-create $AG_NAME --roles Administrator --service-name containers-kubernetes $ADD_RG

# Log Analysis
#ibmcloud iam access-group-policy-create $AG_NAME --roles Editor --service-name ibmloganalysis $ADD_RG

# Monitoring
#ibmcloud iam access-group-policy-create $AG_NAME --roles Editor --service-name monitoring $ADD_RG

# ICD Postgres
#ibmcloud iam access-group-policy-create $AG_NAME --roles Administrator --service-name databases-for-postgresql $ADD_RG

# KMS
#ibmcloud iam access-group-policy-create $AG_NAME --roles Manager,Administrator --service-name kms $ADD_RG

## Give Access with a Resource Group
## ---------------------------------
ibmcloud iam access-group-policy-create $AG_NAME --roles Viewer --resource-type resource-group --resource $RG

## Add User to the Access Group
## ----------------------------
# ibmcloud iam access-group-user-add $AG_NAME first.last@company.com
# ibmcloud iam access-group-user-add $AG_NAME first.last@company.com first2.last2@company.com