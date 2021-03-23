#!/bin/bash

source satellite.env

# ---------------------------------------------------------------------------
# Create Account Structure
# ---------------------------------------------------------------------------
# Create a Resource Group if does not exist
if [ -z $(ibmcloud resource groups | grep -i $RG_NAME | awk '{ print $1}') ]; then
  ibmcloud resource group-create $RG_NAME
else
  printf "\n## Resource Group \"$RG_NAME\" already exists.\n"
fi

ibmcloud target -g $RG_NAME

# ---------------------------------------------------------------------------
# Create VPC if not already there
# ---------------------------------------------------------------------------
if [ -z $(ibmcloud is vpcs | grep -i $VPC_NAME | awk '{ print $2}') ]; then
  # Create a VPC
  printf "\n## Creating vpc \"$VPC_NAME\".\n"
  VPC_ID=$(ibmcloud is vpc-create $VPC_NAME \
                                      --address-prefix-management manual \
                                      --resource-group-name $RG_NAME --json \
                                      | jq -r '.id')

  # Create VPC address specific
  ibmcloud is vpc-addrc sub-01 $VPC_ID eu-de-1 10.243.0.0/18

  # Create Public Gateway for the subnet
  printf "\n## Creating a public gateway \"$VPC_NAME-subnet-01-pgw\" in \"$VPC_ID\" zone \"$VPC_ZONE-1\".\n"
  PGW_01_ID=$(ibmcloud is public-gateway-create $VPC_NAME-subnet-01-pgw $VPC_ID $VPC_ZONE-1 --json | jq -r '.id')

  # Create subnet for your VPC.
  printf "\n## Creating subnet \"$VPC_NAME-subnet-01\" in \"$VPC_ID\".\n"
  VPC_SUB_01_ID=$(ibmcloud is subnet-create $VPC_NAME-subnet-01 $VPC_ID \
                                        --zone eu-de-1 \
                                        --ipv4-cidr-block 10.243.0.0/24 \
                                        --public-gateway-id $PGW_01_ID \
                                        --resource-group-name $RG_NAME --json \
                                        | jq -r '.id')

  # Create the security group for your VPC.
  # SG_ID=$(ibmcloud is security-group-create sat-sg $VPC_ID --json | jq -r '.id')

  # Allow hosts to be attached to a location and assigned to services in the location
  # ibmcloud is security-group-rule-add $SG_ID outbound tcp --port-min 443 --port-max 443 --json

else
  printf "\n## VPC \"$VPC_NAME\" already exists. Fetching VPC id...\n"
  # Retrieving existing the VPC and Subnet IDs for hosts creation later
  export VPC_ID=$(ibmcloud is vpcs | grep -i $VPC_NAME | awk '{ print $1}')
  export VPC_SUB_01_ID=$(ibmcloud is subnets --resource-group-name $RG_NAME | grep -i $SUBNET_NAME | awk '{ print $1}')
  printf "VPC ID:    \"$VPC_ID\"\n"
  printf "Subnet ID: \"$VPC_SUB_01_ID\""
fi
printf "\n## ----------------------------------------------------"


# ---------------------------------------------------------------------------
# Create New Satellite location
# ---------------------------------------------------------------------------
printf "\n## Creating new Satellite location \"$SAT_LOCATION_NAME\".\n"
ibmcloud sat location create --name $SAT_LOCATION_NAME \
                             --managed-from $SAT_MANAGED_FROM \
                             --ha-zone zone-1 --ha-zone zone-2 --ha-zone zone-3

# Retrieve the id of the newly created Satellite location
export SAT_LOCATION_ID=$(ibmcloud sat location get --location $SAT_LOCATION_NAME --json | jq ".id")

# Get the registration script to attach hosts to the Satellite location.
printf "\n## Retrieving the registration script.\n"
assign_host_script=$(ibmcloud sat host attach --location $SAT_LOCATION_NAME | grep register-host)
echo $assign_host_script

# Update the Assign Host script to refresh the Red Hat packages on those hosts.
printf "\n## Updating the Register host script.\n"
sed -i "" -e $'18 a\
subscription-manager refresh\\\n' $assign_host_script
sed -i "" -e $'19 a\
subscription-manager repos --enable=*\\\n' $assign_host_script
printf "\n## ----------------------------------------------------"


# ---------------------------------------------------------------------------
# Create Hosts and attach them to the location
# ---------------------------------------------------------------------------
printf "\n## Creating 6 hosts required for Satellite...\n"

# Create VSIs for Control Plane
createHostsForControlPlane(){
  printf "\n############# VSI sat-$SAT_LOCATION_NAME-cp$i ##############\n"
  ibmcloud is instance-create sat-$SAT_LOCATION_NAME-cp$i \
                              $VPC_ID $VPC_ZONE-1 $VSI_PROFILE \
                              $VPC_SUB_01_ID \
                              --image-id $VSI_IMAGE_ID \
                              --user-data @$assign_host_script
}

# Create VSIs for Worker Node
createHostsForWorkerNode(){
  printf "\n############# VSI sat-$SAT_LOCATION_NAME-wn$i ##############\n"
  ibmcloud is instance-create sat-$SAT_LOCATION_NAME-wn$i \
                              $VPC_ID $VPC_ZONE-1 $VSI_PROFILE \
                              $VPC_SUB_01_ID \
                              --image-id $VSI_IMAGE_ID \
                              --user-data @$assign_host_script
}

# Assign hosts to the location
assignControlPlaneToLocation(){
  printf "\n############# Assign sat-$SAT_LOCATION_NAME-cp$i ##############\n"
    ibmcloud sat host assign --location $SAT_LOCATION_NAME \
                             --host sat-$SAT_LOCATION_NAME-cp$i \
                             --zone zone-$i
}

for i in $(seq -w $COUNT_START $COUNT_END)
do
  createHostsForControlPlane
  createHostsForWorkerNode
done

# Let's wait for few minutes so that location and hosts are visible
cp_count=$(ibmcloud sat host ls --location $SAT_LOCATION_NAME | grep $SAT_LOCATION_NAME-cp | wc -l)
while [ $cp_count -lt $COUNT_END ]
do
  echo "Waiting 30 secs for $COUNT_END control plane hosts to be attached..."
  echo "Number of cp hosts currently attached : $cp_count"
  cp_count=$(ibmcloud sat host ls --location $SAT_LOCATION_NAME | grep $SAT_LOCATION_NAME-cp | wc -l)
  sleep 30
done

for i in $(seq -w $COUNT_START $COUNT_END)
do
   assignControlPlaneToLocation
done

printf "\n## ----------------------------------------------------\n"
