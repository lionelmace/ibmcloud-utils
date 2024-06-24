oc create secret generic odm-db-credentials --from-env-file=odm-db-credentials.env

helm install odm23-on-roks ibm-helm/ibm-odm-prod --version 23.2.11 -f roks-values-externaldb.yaml