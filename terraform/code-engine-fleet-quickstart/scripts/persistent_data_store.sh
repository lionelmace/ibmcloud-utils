#!/bin/bash
set -euo pipefail

# Check env variables
function check_env_variables() {
    if [[ -z "${IBMCLOUD_API_KEY}" ]]; then
        echo "IBMCLOUD_API_KEY is required" >&2
        exit 1
    fi

    if [[ -z "${RESOURCE_GROUP_ID}" ]]; then
        echo "RESOURCE_GROUP_ID is required" >&2
        exit 1
    fi

    if [[ -z "${CE_PROJECT_NAME}" ]]; then
        echo "CE_PROJECT_NAME is required" >&2
        exit 1
    fi

    if [[ -z "${REGION}" ]]; then
        echo "REGION is required" >&2
        exit 1
    fi

    if [[ -z "${BUCKET_STORE_MAP}" ]]; then
        echo "BUCKET_STORE_MAP is required" >&2
        exit 1
    fi

    if [[ -z "${COS_ACCESS_SECRET}" ]]; then
        echo "COS_ACCESS_SECRET is required" >&2
        exit 1
    fi

}

# Log in to IBM Cloud
function ibmcloud_login() {
    printf "\n#### IBM CLOUD LOGIN ####\n\n"
    attempts=1
    until ibmcloud login -r "${REGION}" -g "${RESOURCE_GROUP_ID}" --quiet || [ $attempts -ge 3 ]; do
        attempts=$((attempts + 1))
        echo "Error logging in to IBM Cloud CLI..."
        sleep 3
    done
    printf "\nLogin complete\n"
}

# check env variables
check_env_variables

# ibm cloud login
ibmcloud_login

# select the right code engine project
ibmcloud ce project select -n "${CE_PROJECT_NAME}"

# Read buckets into an array
BUCKETS=()
while IFS= read -r line; do
  BUCKETS+=("$line")
done < <(echo "$BUCKET_STORE_MAP" | jq -r 'keys[]')

# Read stores into an array
STORES=()
while IFS= read -r line; do
  STORES+=("$line")
done < <(echo "$BUCKET_STORE_MAP" | jq -r '.[]')

# Now BUCKETS and STORES are arrays with matching indices and we can create persistent data store
for i in "${!BUCKETS[@]}"; do
    ibmcloud ce pds create --name "${STORES[$i]}" \
        --cos-bucket-name "${BUCKETS[$i]}" \
        --cos-bucket-location "$REGION" \
        --cos-access-secret "$COS_ACCESS_SECRET"
done