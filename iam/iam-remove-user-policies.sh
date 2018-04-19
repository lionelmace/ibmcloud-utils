#!/bin/sh
##listofusers = firstname.lastname@fr.ibm.com xx.xxx@gmail.com xx.xxx@gmail.com

for user in firstname.lastname@fr.ibm.com xx.xxx@gmail.com xx.xxx@gmail.com
do
	echo $user
    # Retrieve policies assigned to the user
    # policies=$(bx iam user-policies $user)
    # OK Policy ID: 1bc955f2-f9c1-49be-a7de-3eb0ddd9c52f Roles: Viewer Resources: Service Name Service Instance Region Resource Type resource-group Resource c9dcb01f2b4a4ba79aab7bad93e326c3 Roles: Administrator Resources: Service Name containers-kubernetes Service Instance Region Resource Type Resource 
    # OK Policy ID: 1bc955f2-f9c1-49be-a7de-3eb0ddd9c53f Roles: Viewer Resources: Service Name
    for policies in $(bx iam user-policies $user| awk -v FS="ID:" '{print $2}' | awk '{print $1}')
    do
        # echo $i
        # Delete Policy
        # bx iam user-policy-delete USER_ID POLICY_ID [-f, --force]
        bx iam user-policy-delete $user $policies -f
    done
done
