#!/bin/sh

## Assign Administrator role to a user with the following policies:
## 1. All account management services
## 2. All resources in account (including future IAM enabled services)
## 3. All User Management resources

for email in first.lastname@company.com

do
  # List the current user policies
  echo $email
  # ibmcloud iam user-policies $email

  # Add Policy: All account management services
  ibmcloud iam user-policy-create $email --roles Administrator --service-type platform_service
  
  # Add Policy: All Identity and Access enabled services
  # Become
  # All resources in account (including future IAM enabled services)
  # All resources in ale-watson resource group
  ibmcloud iam user-policy-create $email --roles Administrator,Manager --service-type service

  # Add Policy: All User Management resources
  ibmcloud iam user-policy-create $email --roles Administrator --service-name user-management 

done
