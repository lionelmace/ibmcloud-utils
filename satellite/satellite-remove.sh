#!/bin/bash

start_time="$(date -u +%s)"

source satellite.env

if [ -z $SATELLITE_LOCATION_NAME ]; then
  SAT_LOCATION_NAME=$LOCATION_NAME
else
  SAT_LOCATION_NAME=$SATELLITE_LOCATION_NAME
fi
RG_NAME=$SAT_LOCATION_NAME-rg
VPC_NAME=$SAT_LOCATION_NAME-vpc
VPC_SUBNET_NAME=$SAT_LOCATION_NAME-subnet
COS_INSTANCE_NAME=$SAT_LOCATION_NAME-cos
COS_BUCKET_NAME=$SAT_LOCATION_NAME-bucket

ibmcloud target -g $RG_NAME

# Create VSIs for Control Plane
deleteHostsForControlPlane(){
  printf "\n### VSI $SAT_LOCATION_NAME-cp$i \n"
  instance_id=$(ibmcloud is instances | grep $SAT_LOCATION_NAME-cp$i  | awk '{print $1}')
  if [ ! -z $instance_id ]; then
    ibmcloud is instance-delete --force $instance_id 
  fi
}

# Create VSIs for Worker Node
deleteHostsForWorkerNode(){
  printf "\n### VSI $SAT_LOCATION_NAME-wn$i \n"
  # ibmcloud is instance-delete --force $(ibmcloud is instances | grep $SAT_LOCATION_NAME-wn$i  | awk '{print $1}')
  instance_id=$(ibmcloud is instances | grep $SAT_LOCATION_NAME-wn$i  | awk '{print $1}')
  if [ ! -z $instance_id ]; then
    ibmcloud is instance-delete --force $instance_id 
  fi
}

# Assign hosts to the location
detachControlPlaneFromLocation(){
  printf "\n### Detach Controlplane host $SAT_LOCATION_NAME-cp$i \n"
    ibmcloud sat host rm -f --location $SAT_LOCATION_NAME \
                        --host $SAT_LOCATION_NAME-cp$i
}

detachWokerNodeFromLocation(){
  printf "\n### Detach Worker host $SAT_LOCATION_NAME-cp$i \n"
    ibmcloud sat host rm -f --location $SAT_LOCATION_NAME \
                        --host $SAT_LOCATION_NAME-wn$i
}

for i in $(seq -w $COUNT_START $COUNT_END)
do
  detachControlPlaneFromLocation
  detachWokerNodeFromLocation
done

# # Location creation takes few minutes and hosts to be visible in this location
cp_count=$(ibmcloud sat host ls --location $SAT_LOCATION_NAME | grep "assigned" | wc -l)
while [ $cp_count -gt 0 ]
do
  echo "Waiting for $COUNT_END control plane hosts to be dettached"
  echo "Number of cp hosts currently attached : $cp_count"
  cp_count=$(ibmcloud sat host ls --location $SAT_LOCATION_NAME | grep "assigned" | wc -l)
  sleep 30
done

# Delete Satellite location
printf "\n### Deleting Satellite location \"$SAT_LOCATION_NAME\".\n"
ibmcloud sat location rm -f --location $SAT_LOCATION_NAME

loc_count=$(ibmcloud sat location ls | grep $SAT_LOCATION_NAME-cp | wc -l)
while [ $cp_count -gt 0 ]
do
  echo "Waiting for $COUNT_END control plane hosts to be attached"
  echo "Number of cp hosts currently attached : $cp_count"
  loc_count=$(ibmcloud sat location ls | grep $SAT_LOCATION_NAME-cp | wc -l)
  sleep 30
done

for i in $(seq -w $COUNT_START $COUNT_END)
do
  echo "Deleting cp and wn $i"
  deleteHostsForControlPlane
  deleteHostsForWorkerNode
done

# Delete Subnet
export VPC_SUBNET_ID=$(ibmcloud is subnets --resource-group-name $RG_NAME | grep -i $VPC_SUBNET_NAME | awk '{ print $1}')
# export VPC_SUBNET_ID=$(ibmcloud is subnets --resource-group-name $RG_NAME | awk 'FNR > 2 { print $1 }')
ibmcloud is subnetd $VPC_SUBNET_ID -f

# Delete Public Gateway
export VPC_PUBLIC_GTW=$(ibmcloud is pubgws --resource-group-name $RG_NAME | grep -i $SAT_LOCATION_NAME | awk 'FNR > 1 { print $1}')
ibmcloud is pubgwd $VPC_PUBLIC_GTW -f
  
# Delete VPC
export VPC_ID=$(ibmcloud is vpcs | grep -i $VPC_NAME | awk '{ print $1}')
ibmcloud is vpcd $VPC_ID -f

# Delete COS instance and attached resource keys
cos_tbd=$(ibmcloud resource service-instances | grep $COS_INSTANCE_NAME)
if [ ! -z $cos_tbd ]; then
  ibmcloud resource service-instance-delete $cos_tbd -f --recursive
fi

# Delete Resource Group
ibmcloud resource group-delete $RG_NAME -f

# Display duration time
end_time="$(date -u +%s)"
elapsed_in_secs="$(($end_time-$start_time))"
echo "Total of $(($elapsed_in_secs / 60)) mins and $(($elapsed_in_secs % 60)) secs elapsed."