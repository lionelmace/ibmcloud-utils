#!/bin/sh

## DEPRECATED ## 
## This is better to create an Access Group first
## Shell script to do the following
## 1. Extract the last name from the email address
## 2. Create a Cloud Foundry space with the last name
## 3. Invite the user into the newly created space
## 4. Assign policy to the use so he can create a Kube cluster and use both Log Analysis and Monitoring service

## Resource Group
RG="workshop"

for email in first.lastname@company.com

do
  ## Extract last name from email
  lastname=$(echo $email | awk -F'@' '{print $1}' | sed 's?.*\.??g' | sed 's?.*\_??g' )

  ## Create a Cloud Foundry space with the last name
  echo $lastname
  #ibmcloud account space-create $lastname

  ## Invite user and assign role developer to this space
  #ibmcloud account user-invite $email -o cloud-workshop -s $lastname --space-role SpaceDeveloper

  ## Give Editor access to a Resource Group (Not the right command)
  ibmcloud iam user-policy-create lionel.mace@gmail.com --roles Viewer --resource-type resource-group --resource a260658ac8b14975827b8d6b3d146aea
  # a260658ac8b14975827b8d6b3d146aea
  # ibmcloud iam user-policy-create $email --roles Viewer --resource-group-name $RG

  ## Assign access within a Resource Group
  RG_ONLY=true
  ADD_RG=""
  if ($RG_ONLY)
  then ADD_RG="--resource-group-name $RG"
  fi 
  echo $ADD_RG

  ## Assign Policy
  # Cloudant
  ibmcloud iam user-policy-create $email --roles Manager,Editor --service-name cloudantnosqldb $ADD_RG
  # Log Analysis
  ibmcloud iam user-policy-create $email --roles Editor --service-name ibmloganalysis $ADD_RG
  # Continuous Delivery
  ibmcloud iam user-policy-create $email --roles Editor,Writer --service-name continuous-delivery $ADD_RG
  ibmcloud iam user-policy-create $email --roles Editor --service-name toolchain $ADD_RG
  # Container
  ibmcloud iam user-policy-create $email --roles Manager,Administrator --service-name container-registry $ADD_RG
  ibmcloud iam user-policy-create $email --roles Administrator --service-name containers-kubernetes $ADD_RG
  # Monitoring
  ibmcloud iam user-policy-create $email --roles Editor --service-name monitoring $ADD_RG
  # ICD Postgres
  #ibmcloud iam user-policy-create $email --roles Administrator --service-name databases-for-postgresql $ADD_RG
  # KMS
  #ibmcloud iam user-policy-create $email --roles Manager,Administrator --service-name kms $ADD_RG

done
