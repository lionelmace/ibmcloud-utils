#!/bin/sh

source ../local.env

ibmcloud target -g $RESOURCE_GROUP_NAME

IAM_TOKEN=$(ibmcloud iam oauth-tokens | grep IAM | awk '{print $4}')

export SERVER_URL=$(ibmcloud ks cluster get --cluster $CLUSTER_NAME --json | jq ".serverURL")
INGRESS_URL=$(ibmcloud ks cluster get --cluster iro --json | jq ".ingressHostname" | tr -d '"')
CLUSTER_ID=$(ibmcloud ks cluster get --cluster iro --json | jq ".id" | tr -d '"')
sleep 4
printf "## Logging into OpenShift Cluster $CLUSTER_NAME\n"
oc login -u apikey -p ${APIKEY} --server=${SERVER_URL//\"} --insecure-skip-tls-verify=true

for email in $EMAIL

do
  ## Extract last name from email
  lastname=$(echo $email | awk -F'@' '{print $1}' | sed 's?.*\.??g' | sed 's?.*\_??g' )
  project_name="lab-$lastname"

  # Create a new openshift project with the last name
  printf "\n## Creating project $project_name \n"
  oc new-project $project_name

  # Invite user to the account
  printf "\n## Inviting user $email to the account $ACCOUNT_ID\n"
  ibmcloud account user-invite $email

  # Assign IAM User Policy
  printf "\n## Assigning user policy Platform Viewer to the user $email\n"
  ibmcloud iam user-policy-create $email --roles Viewer --service-name containers-kubernetes --service-instance $CLUSTER_ID
  #ibmcloud iam user-policy-create $email --roles Viewer,Writer --service-name containers-kubernetes --service-instance $CLUSTER_ID --attributes "namespace=$project_name"

  # Add edit role to the user so they can work within the project $project_name
  printf "\n## Add Edit role to the user $email so he can work within the project $project_name\n"
  oc adm policy add-role-to-user edit IAM#$email -n $project_name

  # Access has been granted
  printf "\n## You can now view the cluster $CLUSTER_NAME overview:\n"
  printf "https://cloud.ibm.com/kubernetes/clusters/$CLUSTER_ID?bss_account=$ACCOUNT_ID"
  printf "\n## You now have access the project $project_name inside the Openshift cluster:\n"
  ## URL to access the OpenShift Console and enter credentials
  ## Example: https://console-openshift-console.iro-541970-483cccd2f0d38128dd40d2b711142ba9-0000.eu-de.containers.appdomain.cloud/topology/ns/lab-mace
  echo https://console-openshift-console.$INGRESS_URL
done