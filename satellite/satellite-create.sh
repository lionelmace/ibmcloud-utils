#!/bin/sh
# Uncommment to verbose
# set -x 

source satellite.env

ibmcloud target -g $RESOURCE_GROUP_NAME


# Create a new Satellite location
printf "\n## Creating new Satellite location \"$SAT_LOCATION_NAME\".\n"
# ibmcloud sat location create --name $SAT_LOCATION_NAME --managed-from $SAT_MANAGED_FROM

# Retrieve the id of the newly created Satellite location
export SAT_LOCATION_ID=$(ibmcloud sat location get --location $SAT_LOCATION_NAME --json | jq ".id")

# Get the registration script to attach hosts to the Satellite location.
ibmcloud sat host attach --location $SAT_LOCATION_NAME
export SAT_LOCATION_SCRIPT=$(ibmcloud sat host attach --location $SAT_LOCATION_NAME)
printf "Script location" $SAT_LOCATION_SCRIPT

# Create VSIs for Control Plane
# ibmcloud inc
# ibmcloud is instance-create $SAT_LOCATION_NAME-controlplane 72b27b5c-f4b0-48bb-b954-5becc7c1dcb8 us-south-1 bx2-2x8 72b27b5c-f4b0-48bb-b954-5becc7c1dcb8 --image-id r123-72b27b5c-f4b0-48bb-b954-5becc7c1dcb8

# Create VSIs for Worker Node

printf "\n## ----------------------------------------------------\n"


# for igs in $IGS
# do
#   # Create a new Satellite location
#   printf "\n## Creating new Satellite location \"$SAT_LOCATION_NAME\".\n"
#   is is satellite location create --name $SAT_LOCATION_NAME --managed-from eu-gb


#   printf "\n## ----------------------------------------------------\n"
# done