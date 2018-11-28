#!/bin/sh

##  Script to invite:
##  1. Create a Cloud Foundry Sapce with the lastname in the email address

## CF Org
ORG="cloud-workshop"

ibmcloud target -o $ORG

for email in first.lastname@company.com
do
	echo $email
	
	## Extract last name from email
	lastname=$(echo $email | awk -F'@' '{print $1}' | sed 's?.*\.??g' | sed 's?.*\_??g' )

	## Create a Cloud Foundry space with the last name
	echo $lastname
	ibmcloud account space-create $lastname

	## Invite user and assign role developer to this space
  	ibmcloud account user-invite $email -o $ORG -s $lastname --space-role SpaceDeveloper

	# Add user into this access groug
	ibmcloud iam access-group-user-add group-workshop $email

	# Create Policy
	# bx iam user-policy-create $email --roles Administrator --service-name containers-kubernetes
	# bx iam user-policy-create $email --roles Administrator --service-name monitoring
	# bx iam user-policy-create $email --roles Administrator --service-name ibmcloud-log-analysis 

done