#!/bin/sh

source ../local.env

IAM_TOKEN=$(ibmcloud iam oauth-tokens | grep IAM | awk '{print $4}')

export SERVER_URL=$(ibmcloud ks cluster get --cluster $CLUSTER_NAME --json | jq ".serverURL")
sleep 4
printf "## Logging into OpenShift Cluster ${SERVER_URL}"
oc login -u apikey -p ${APIKEY} --server=${SERVER_URL//\"} --insecure-skip-tls-verify=true

for email in $EMAIL

do
  # Extract last name from email
  lastname=$(echo $email | awk -F'@' '{print $1}' | sed 's?.*\.??g' | sed 's?.*\_??g' )
  project_name="user-$lastname"

  # Remove edit role from the user
  printf "## Removing Edit role from the user $email in the project $project_name\n"
  oc adm policy remove-role-from-user edit IAM#$email -n $project_name

  # Delete the openshift project
  oc delete project $project_name

  # Remove user from the account and its associated policy
  printf "## Removing user $email from the account $ACCOUNT_ID\n"
  ibmcloud account user-remove $email -f
done
