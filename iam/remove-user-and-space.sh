#!/bin/sh

# Shell script to remove a list of users and their associated Cloud Foundry space

# for email in firstname.lastname@fr.ibm.com xx.xxx@gmail.com xx.xxx@gmail.com

do
	## Extract last name from email
	lastname=$(echo $email | awk -F'@' '{print $1}' | sed 's?.*\.??g' | sed 's?.*\_??g' )
    echo $lastname

	## Delete Cloud Foundry space with the last name
	ibmcloud account space-delete $lastname -f

	## Remove User
	ibmcloud account user-remove $email -f
done