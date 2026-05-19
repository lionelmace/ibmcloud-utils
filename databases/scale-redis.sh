#!/usr/bin/env bash
set -euo pipefail

# Usage:
# ./scale-redis.sh "<INSTANCE_NAME_OR_CRN>"
#
# Target: Small Custom equivalent
# 2 members x 6 GB RAM = 12288 MB total
# 0.75 vCPU/member = 1.5 vCPU total
# IBM CLI CPU value may be expressed as total CPU units; verify with deployment-groups first.

INSTANCE="${1:?Usage: $0 <INSTANCE_NAME_OR_CRN>}"
GROUP_ID="member"

TOTAL_MEMORY_MB="12288"   # 6 GB/member x 2 members
TOTAL_DISK_MB="8192"      # 4 GB/member x 2 members
TOTAL_CPU="2"             # must be integer via CLI

echo "Current resource allocation:"
ibmcloud cdb deployment-groups "$INSTANCE"

echo
echo "Scaling Redis instance..."

if ibmcloud cdb deployment-groups-set "$INSTANCE" "$GROUP_ID" \
  --memory "$TOTAL_MEMORY_MB" \
  --cpu "$TOTAL_CPU" \
  --disk "$TOTAL_DISK_MB" \
  --hostflavor multitenant; then

    echo
    echo "Updated resource allocation:"
    ibmcloud cdb deployment-groups "$INSTANCE"

else
    echo
    echo "FAILED: Redis scaling command failed."
    exit 1
fi