#!/bin/sh
# Uncommment to verbose
# set -x 

source ../local.env

ibmcloud target -g $RESOURCE_GROUP_NAME

export MASTER_URL=$(ibmcloud ks cluster get --cluster $CLUSTER_NAME --json | jq ".masterURL")
INGRESS_URL=$(ibmcloud ks cluster get --cluster $CLUSTER_NAME --json | jq ".ingress.hostname" | tr -d '"')
CLUSTER_ID=$(ibmcloud ks cluster get --cluster $CLUSTER_NAME --json | jq ".id" | tr -d '"')
sleep 4
printf "\n## Logging into OpenShift Cluster \"$CLUSTER_NAME\" ...\n"
oc login -u apikey -p ${APIKEY} --server=${MASTER_URL//\"} --insecure-skip-tls-verify=true

# Give the user a ClusterRoleBinding to the existing aggregate-olm-view ClusterRole
# --------- BEGIN
enableClusterRoleBinding() {
  cat <<EOF | oc apply -f -
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: operators-view-$1
subjects:
  - kind: User
    apiGroup: rbac.authorization.k8s.io
    name: IAM#$2
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: aggregate-olm-view
EOF
}

enableClusterRole()
{
  cat <<EOF | oc apply -f -
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: aggregate-olm-edit2
  labels:
    rbac.authorization.k8s.io/aggregate-to-admin: 'true'
    rbac.authorization.k8s.io/aggregate-to-edit: 'true'
rules:
  - verbs:
      - create
      - update
      - patch
      - delete
    apiGroups:
      - operators.coreos.com
    resources:
      - subscriptions
      - operatorgroups
  - verbs:
      - delete
    apiGroups:
      - operators.coreos.com
    resources:
      - clusterserviceversions
      - catalogsources
      - installplans
      - subscriptions
EOF
}

enableRoleBinding() {
  cat <<EOF | oc apply -f -
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: operators-edit2
  namespace: $1
subjects:
  - kind: User
    apiGroup: rbac.authorization.k8s.io
    name: IAM#$2
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: aggregate-olm-edit2
EOF
}
# --------- END

for email in $EMAIL
do
  # Convert email to lowercase otherwise users with uppercase email cannot see Operator Hub. Weird!
  email=$(echo $email | awk '{print tolower($0)}' )

  ## Extract last name from email and convert to lower case
  lastname=$(echo $email | awk -F'@' '{print $1}' | sed 's?.*\.??g' | sed 's?.*\_??g' )
  project_name="lab-$lastname"

  # Create a new openshift project with the last name
  printf "\n## Creating project $project_name...\n"
  oc new-project $project_name

  # Invite user to the account
  printf "\n## Inviting user $email to the account $ACCOUNT_ID...\n"
  ibmcloud account user-invite $email

  # Assign IAM User Policy - Warning: Those 2 independant policies are required.
  printf "\n## Assigning IAM Platform Viewer to allow the user to see the cluster in the IBM Cloud environment\n"
  ibmcloud iam user-policy-create $email --roles Viewer --service-name containers-kubernetes --service-instance $CLUSTER_ID
  # Grant admin access on the OpenShift project
  printf "\n## Assigning IAM Platform Writer to the project\n"
  ibmcloud iam user-policy-create $email --roles Writer --service-name containers-kubernetes --service-instance $CLUSTER_ID --attributes "namespace=$project_name"

  # Add edit role to the user so they can work within the project $project_name
  # Warning: user will only appear in OpenShift once the user has logged at least once
  # iam_email=$(oc get users | grep -i $email | awk '{ print $1}')
  printf "\n## Add Edit role to the user $email so he can work within the project $project_name...\n"
  # oc adm policy add-role-to-user edit IAM#$email -n $project_name

  # Enable user to install Operator from OperatorHub
  printf "\n## Enabling user to install Operator from OperatorHub...\n"
  enableClusterRoleBinding $lastname $email
  enableClusterRole
  enableRoleBinding $project_name $email

  # Access has been granted
  printf "\n## URL to view the cluster overview in IBM Cloud:\n"
  printf "https://cloud.ibm.com/kubernetes/clusters/$CLUSTER_ID/overview?bss_account=$ACCOUNT_ID"
  printf "\n## URL to access directly the Openshift console:\n"
  # URL to access the OpenShift Console and enter credentials
  # Example: https://console-openshift-console.iro-541970-483cccd2f0d38128dd40d2b711142ba9-0000.eu-de.containers.appdomain.cloud/topology/ns/lab-mace
  echo https://console-openshift-console.$INGRESS_URL

  printf "\n## ----------------------------------------------------\n"
done