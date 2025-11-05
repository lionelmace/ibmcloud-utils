#!/bin/bash
set -euo pipefail

# max wait time = 10 × 10s = 100 seconds
MAX_RETRIES=10
RETRY_INTERVAL=10  # seconds

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

    if [[ -z "${FLEET_COS_SECRET_NAME}" ]]; then
        echo "FLEET_COS_SECRET_NAME is required" >&2
        exit 1
    fi

    if [[ -z "${ACCESS_KEY_ID}" ]]; then
        echo "ACCESS_KEY_ID is required" >&2
        exit 1
    fi

    if [[ -z "${SECRET_ACCESS_KEY}" ]]; then
        echo "SECRET_ACCESS_KEY is required" >&2
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

# create a secret
ibmcloud ce secret create --name "${FLEET_COS_SECRET_NAME}" \
    --format hmac \
    --access-key-id "${ACCESS_KEY_ID}"  \
    --secret-access-key "${SECRET_ACCESS_KEY}"

echo "Waiting for secret to complete..."
retries=0
while true; do
    if ibmcloud ce secret get --name "${FLEET_COS_SECRET_NAME}" > /dev/null 2>&1; then
        echo "Secret exists."
        break
    else
        echo "Secret does not exist."
    fi

    #  if max retry then finish with error
    if [[ $retries -ge $MAX_RETRIES ]]; then
        echo "Secret $FLEET_COS_SECRET_NAME did not create after $MAX_RETRIES retries. Timing out."
        exit 1
    fi

    retries=$((retries + 1))
    sleep "${RETRY_INTERVAL}"
done