#!/bin/bash
echo "Push a ODM docker images to Bluemix..."

# Variables
ODM-VERSION=8.8.1.1
NAMESPACE=mace
REGISTRY=registry.eu-gb.bluemix.net

echo "Tagging the images before pushing them to Bluemix..."
docker tag odm-decisionserverruntime:$ODM_VERSION $REGISTRY/$NAMESPACE/odm-decisionserverruntime:$ODM_VERSION
docker tag odm-decisioncenter:$ODM_VERSION $REGISTRY/$NAMESPACE/odm-decisioncenter:$ODM_VERSION
docker tag odm-decisionrunner:$ODM_VERSION $REGISTRY/$NAMESPACE/odm-decisionrunner:$ODM_VERSION
docker tag odm-decisionserverconsole:$ODM_VERSION $REGISTRY/$NAMESPACE/odm-decisionserverconsole:$ODM_VERSION
docker tag odm-dbserver:$ODM_VERSION $REGISTRY/$NAMESPACE/odm-dbserver:$ODM_VERSION
docker tag dockercloud/haproxy:latest $REGISTRY/$NAMESPACE/dockercloud/haproxy:latest

echo "Pushing the images to Bluemix..."
docker push $REGISTRY/$NAMESPACE/odm-decisionserverruntime:$ODM_VERSION
docker push $REGISTRY/$NAMESPACE/odm-decisioncenter:$ODM_VERSION
docker push $REGISTRY/$NAMESPACE/odm-decisionrunner:$ODM_VERSION
docker push $REGISTRY/$NAMESPACE/odm-decisionserverconsole:$ODM_VERSION
docker push $REGISTRY/$NAMESPACE/odm-dbserver:$ODM_VERSION
docker push $REGISTRY/$NAMESPACE/dockercloud/haproxy:latest

echo "Your registry"
docker images

done