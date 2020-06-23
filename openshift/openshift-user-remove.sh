#!/bin/sh

source ../local.env

ibmcloud target -g $RESOURCE_GROUP_NAME

IAM_TOKEN=$(ibmcloud iam oauth-tokens | grep IAM | awk '{print $4}')

export MASTER_URL=$(ibmcloud ks cluster get --cluster $CLUSTER_NAME --json | jq ".serverURL")
sleep 4
printf "## Logging into OpenShift Cluster $CLUSTER_NAME...\n"
oc login -u apikey -p ${APIKEY} --server=${MASTER_URL//\"} --insecure-skip-tls-verify=true

for email in $EMAIL

do
  # Extract last name from email and convert to lower case
  lastname=$(echo $email | awk -F'@' '{print $1}' | sed 's?.*\.??g' | sed 's?.*\_??g' | awk '{print tolower($0)}' )
  project_name="lab-$lastname"

  # Remove edit role from the user
  printf "## Removing Edit role from the user $email in the project $project_name...\n"
  oc adm policy remove-role-from-user edit IAM#$email -n $project_name

  # Delete the openshift project
  printf "## Deleting the OpenShift project $project_name...\n"
  oc delete project $project_name

  # Delete the user from the list of users in OpenShift User Management
  printf "## Deleting the user IAM#$email from OpenShift User Management...\n"
  iam_email=$(oc get users | grep -i $email | awk '{ print $1}')
  oc delete user $iam_email

  # Remove user from the account and its associated policy
  printf "## Removing user $email from the account $ACCOUNT_ID...\n"
  ibmcloud account user-remove $email -f
done
