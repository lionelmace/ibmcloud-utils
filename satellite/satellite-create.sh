#!/bin/bash

source satellite.env

start_time="$(date -u +%s)"
echo "Started at $(date +"%H:%M")"

if [ -z $SATELLITE_LOCATION_NAME ]; then
  # Use name set in the satellite.env
  SAT_LOCATION_NAME=sat-$LOCATION_NAME
else
  # Override the location name set in satellite.env if set externally
  SAT_LOCATION_NAME=sat-$SATELLITE_LOCATION_NAME
fi
RG_NAME=$SAT_LOCATION_NAME-rg
VPC_NAME=$SAT_LOCATION_NAME-vpc
VPC_SUBNET_NAME=$SAT_LOCATION_NAME-subnet
COS_INSTANCE_NAME=$SAT_LOCATION_NAME-cos
COS_BUCKET_NAME=$SAT_LOCATION_NAME-bucket
SAT_LOG_ANALYSIS=$SAT_LOCATION_NAME-log


# ---------------------------------------------------------------------------
# Create Resource Group
# ---------------------------------------------------------------------------
if [ -z $(ibmcloud resource groups | grep -i $RG_NAME | awk '{ print $1}') ]; then
  ibmcloud resource group-create $RG_NAME
else
  printf "\n### Resource Group \"$RG_NAME\" already exists.\n"
fi

ibmcloud target -g $RG_NAME

# ---------------------------------------------------------------------------
# Create VPC, Subnet, Public Gateway
# ---------------------------------------------------------------------------
if [ -z $(ibmcloud is vpcs | grep -i $VPC_NAME | awk '{ print $2}') ]; then
  # Create VPC
  printf "\n### Creating vpc \"$VPC_NAME\".\n"
  VPC_ID=$(ibmcloud is vpc-create $VPC_NAME \
                                      --address-prefix-management manual \
                                      --resource-group-name $RG_NAME --json \
                                      | jq -r '.id')

  # Create VPC address specific
  # printf "\n### Creating an address prefix.\n"
  ibmcloud is vpc-addrc sub-01 $VPC_ID eu-de-1 10.243.0.0/18

  # Create Public Gateway for the subnet
  printf "\n### Creating a public gateway \"$VPC_NAME-subnet-01-pgw\" in \"$VPC_NAME\" zone \"$VPC_ZONE-1\".\n"
  PGW_01_ID=$(ibmcloud is public-gateway-create $VPC_NAME-subnet-01-pgw $VPC_ID $VPC_ZONE-1 --json | jq -r '.id')

  # Create subnet for your VPC.
  printf "\n### Creating subnet \"$VPC_SUBNET_NAME-01\" in \"$VPC_NAME\".\n"
  VPC_SUB_01_ID=$(ibmcloud is subnet-create $VPC_SUBNET_NAME-01 $VPC_ID \
                                        --zone eu-de-1 \
                                        --ipv4-cidr-block 10.243.0.0/24 \
                                        --public-gateway-id $PGW_01_ID \
                                        --resource-group-name $RG_NAME \
                                        --output json \
                                        | jq -r '.id')

  # Create the security group for your VPC.
  # SG_ID=$(ibmcloud is security-group-create sat-sg $VPC_ID --json | jq -r '.id')

  # Allow hosts to be attached to a location and assigned to services in the location
  # ibmcloud is security-group-rule-add $SG_ID outbound tcp --port-min 443 --port-max 443 --json
fi


# ---------------------------------------------------------------------------
# Create COS (Cloud Object Storage) and Bucket dedicated for the location
# COS is required for Satellite
# ---------------------------------------------------------------------------
# if [ -z $(ibmcloud cos bucket-head --bucket cos-satellite-bucket) ]; then
  printf "\n### Creating a COS service for the location \"$COS_INSTANCE_NAME\". \n"
  ibmcloud resource service-instance-create $COS_INSTANCE_NAME cloud-object-storage standard global
  export COS_CRN=$(ibmcloud resource service-instance $COS_INSTANCE_NAME --id | grep crn | awk '{print $1}')

  printf "\n### Creating a COS bucket \"$COS_BUCKET_NAME\". \n"
  ibmcloud cos bucket-create --bucket $COS_BUCKET_NAME \
                             --class Standard \
                             --ibm-service-instance-id $COS_CRN \
                             --region $VPC_ZONE
# fi

# ---------------------------------------------------------------------------
# Create a Platform Log Analysis service
# ---------------------------------------------------------------------------
# printf "\n### Creating a Log Analysis service \"$SAT_LOG_ANALYSIS\".\n"
# Not used yet as there is no way to check wherever there is already a platform logs instance
# LOG_ID=$(ibmcloud resource service-instance-create $SAT_LOG_ANALYSIS logdna 7-day $SAT_MANAGED_FROM -g $RG_NAME -p '{"default_receiver": true}')


# ---------------------------------------------------------------------------
# Create a Satellite location
# ---------------------------------------------------------------------------
printf "\n### Creating the Satellite location \"$SAT_LOCATION_NAME\".\n"
ibmcloud sat location create --name $SAT_LOCATION_NAME \
                             --managed-from $SAT_MANAGED_FROM \
                             --ha-zone zone-1 --ha-zone zone-2 --ha-zone zone-3 \
                             --cos-bucket $COS_BUCKET_NAME

# Retrieve the id of the newly created Satellite location
export SAT_LOCATION_ID=$(ibmcloud sat location get --location $SAT_LOCATION_NAME --json | jq ".id")

# Get the registration script to attach hosts to the Satellite location.
printf "\n### Retrieving the registration script.\n"
assign_host_script=$(ibmcloud sat host attach --location $SAT_LOCATION_NAME | grep register-host)
echo $assign_host_script

# Update the Assign Host script to refresh the Red Hat packages on those hosts.
printf "\n### Updating the Register host script.\n"
sed -i "" -e $'18 a\
subscription-manager refresh\\\n' $assign_host_script
sed -i "" -e $'19 a\
subscription-manager repos --enable=*\\\n' $assign_host_script


# ---------------------------------------------------------------------------
# Create Hosts and attach them to the location
# ---------------------------------------------------------------------------
printf "\n### Creating 6 hosts required for Satellite...\n"

# Create VSIs for Control Plane
createHostsForControlPlane(){
  printf "\n### VSI $SAT_LOCATION_NAME-cp$i \n"
  ibmcloud is instance-create $SAT_LOCATION_NAME-cp$i \
                              $VPC_ID $VPC_ZONE-1 $VSI_PROFILE \
                              $VPC_SUB_01_ID \
                              --image-id $VSI_IMAGE_ID \
                              --user-data @$assign_host_script \
                              --resource-group-name $RG_NAME
}

# Create VSIs for Worker Node
createHostsForWorkerNode(){
  printf "\n### VSI $SAT_LOCATION_NAME-wn$i \n"
  ibmcloud is instance-create $SAT_LOCATION_NAME-wn$i \
                              $VPC_ID $VPC_ZONE-1 $VSI_PROFILE \
                              $VPC_SUB_01_ID \
                              --image-id $VSI_IMAGE_ID \
                              --user-data @$assign_host_script \
                              --resource-group-name $RG_NAME
}

# Assign hosts to the location
assignControlPlaneToLocation(){
  printf "\n### Assign $SAT_LOCATION_NAME-cp$i \n"
  ibmcloud sat host assign --location $SAT_LOCATION_NAME \
                           --host $SAT_LOCATION_NAME-cp$i \
                           --zone zone-$i
}

for i in $(seq -w $COUNT_START $COUNT_END)
do
  createHostsForControlPlane
  createHostsForWorkerNode
done

printf "\n### Let's wait for 7+ mins so that location \"$SAT_LOCATION_NAME\" and hosts are visible \n"
echo "Started at $(date +"%H:%M")"
cp_count=$(ibmcloud sat host ls --location $SAT_LOCATION_NAME | grep $SAT_LOCATION_NAME-cp | wc -l)
while [ $cp_count -lt $COUNT_END ]
do
  echo "Checking every minute for $COUNT_END control plane hosts to be attached..."
  echo "Number of cp hosts currently attached : $cp_count"
  cp_count=$(ibmcloud sat host ls --location $SAT_LOCATION_NAME | grep $SAT_LOCATION_NAME-cp | wc -l)
  sleep 60
done

printf "\n### Assigning control plane to the location \"$SAT_LOCATION_NAME\"... \n"
for i in $(seq -w $COUNT_START $COUNT_END)
do
   assignControlPlaneToLocation
done

end_time="$(date -u +%s)"
echo "Ended at $(date +"%H:%M")"

elapsed_in_secs="$(($end_time-$start_time))"
echo "Total of $(($elapsed_in_secs / 60)) mins and $(($elapsed_in_secs % 60)) secs elapsed."

printf "\n### ----------------------------------------------------\n"
printf "You no need to wait for 30-40 mins while Satellite sets up the location control plane.\n"
printf "Location Status will remain \"Action required\"... until it changes to \"Normal\". \n"
printf "Check the Status on the Satellite page:\n"
export ACCOUNT_ID=$(ibmcloud account show | grep "Account ID" | awk '{print $3}')
export LOC_ID=$(echo "$SAT_LOCATION_ID" | tr -d '"')
echo https://cloud.ibm.com/satellite/locations/$LOC_ID/hosts?bss_account=$ACCOUNT_ID
printf "### ----------------------------------------------------\n"