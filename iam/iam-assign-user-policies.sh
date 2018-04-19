#!/bin/sh
##listofusers = firstname.lastname@fr.ibm.com xx.xxx@gmail.com xx.xxx@gmail.com

# Formation interne Kubernetes
for i in firstname.lastname@fr.ibm.com xx.xxx@gmail.com xx.xxx@gmail.com
do
	echo $i
	# Create Policy
	bx iam user-policy-create $i --roles Administrator --service-name containers-kubernetes
	bx iam user-policy-create $i --roles Administrator --service-name monitoring
	bx iam user-policy-create $i --roles Administrator --service-name ibmcloud-log-analysis 

done
