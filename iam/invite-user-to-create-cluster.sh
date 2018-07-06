#!/bin/sh

# Shell script to do the following
# 1. Extract the last name from the email address
# 2. Create a Cloud Foundry space with the last name
# 3. Invite the user into the newly created space
# 4. Assign policy to the use so he can create a Kube cluster and use both Log Analysis and Monitoring service

for email in firstname.lastname@fr.ibm.com xx.xxx@gmail.com xx.xxx@gmail.com

do
  ## Extract last name from email
  lastname=$(echo $email | awk -F'@' '{print $1}' | sed 's?.*\.??g' | sed 's?.*\_??g' )

  ## Create a Cloud Foundry space with the last name
  echo $lastname
  ibmcloud account space-create $lastname

  ## Invite user and assign role developer to this space
  ibmcloud account user-invite $email -o cloud-europe -s $lastname --space-role SpaceDeveloper

  ## Assign Policy
  ibmcloud iam user-policy-create $email --roles Administrator --service-name containers-kubernetes
  ibmcloud iam user-policy-create $email --roles Administrator --service-name monitoring
  ibmcloud iam user-policy-create $email --roles Administrator --service-name ibmcloud-log-analysis 

done
