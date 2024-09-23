export ICL_AGENT_VERSION=1.2.4
export CLUSTER_TYPE=Kubernetes
export REGION=eu-de

curl -sSL https://ibm.biz/logs-router-setup | bash -s -- \
   -v $ICL_AGENT_VERSION \
   -m IAMAPIKey \
   -k $APIKEY \
   -t $CLUSTER_TYPE \
   -r $REGION \
   --send-directly-to-icl \
   -h 8f7dab9d-6a0e-4bc0-9e36-7cbe49f61fe0.ingress.eu-de.logs.cloud.ibm.com \
   -p 443