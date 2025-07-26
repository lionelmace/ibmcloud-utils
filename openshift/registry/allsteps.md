ibmcloud ks cluster config -c icn-roks --admin
oc -n openshift-image-registry get deployment image-registry\n
oc get configs.imageregistry.operator.openshift.io/cluster -o yaml\n
oc get pod -n openshift-image-registry -l docker-registry=default -o jsonpath='{.items[0].spec.containers[0].env}' | jq\n
oc get pods -n openshift-image-registry
oc describe clusteroperator image-registry\n
oc patch configs.imageregistry.operator.openshift.io/cluster \\n--type=merge -p '{"spec":{"managementState":"Removed"}}'
oc describe clusteroperator image-registry\n
oc get clusteroperator image-registry\n
oc get pods -n openshift-image-registry\n
oc get pod -n openshift-image-registry -l docker-registry=default -o jsonpath='{.items[0].spec.containers[0].env}' | jq\n
oc get pod -n openshift-image-registry -l docker-registry=default -o jsonpath='{.items[0].spec.containers[0].env}'\n
oc get configs.imageregistry.operator.openshift.io/cluster -o yaml\n
oc edit configs.imageregistry.operator.openshift.io/cluster -o yaml
oc get configs.imageregistry.operator.openshift.io/cluster -o yaml\n
oc get secrets -n openshift-image-registry
oc get pod -n openshift-image-registry -l docker-registry=default -o jsonpath='{.items[0].spec.containers[0].env}' | jq\n
oc patch configs.imageregistry.operator.openshift.io/cluster \\n--type=merge -p '{"spec":{"managementState":"Managed"}}'
oc rollout restart deployment image-registry -n openshift-image-registry\n
oc get pod -n openshift-image-registry -l docker-registry=default -o jsonpath='{.items[0].spec.containers[0].env}' | jq\n


oc patch configs.imageregistry.operator.openshift.io/cluster \\n--type=merge -p '{"spec":{"managementState":"Removed"}}'
oc patch configs.imageregistry.operator.openshift.io/cluster \\n  --type=json \\n  -p '[{"op": "remove", "path": "/spec/storage/emptyDir"}]'
COS_BUCKET_NAME=roks-d1o0cd9f0jl2j2kett8g-9ab2
oc patch configs.imageregistry.operator.openshift.io/cluster --type=merge -p "$(cat <<EOF\n{\n"spec": {\n  "managementState": "Unmanaged",\n    "storage": {\n      "s3": {\n        "bucket": "$COS_BUCKET_NAME",\n        "region": "eu-de-standard",\n        "regionEndpoint": "https://s3.direct.eu-de.cloud-object-storage.appdomain.cloud",\n        "trustedCA": {\n          "name": ""\n        },\n        "virtualHostedStyle": false\n      }\n    }\n  }\n}\nEOF\n)"
oc get configs.imageregistry.operator.openshift.io/cluster -o yaml\n
oc patch configs.imageregistry.operator.openshift.io/cluster \\n--type=merge -p '{"spec":{"managementState":"Managed"}}'
oc rollout restart deployment image-registry -n openshift-image-registry\n
oc get clusteroperator image-registry\n
oc get pods -n openshift-image-registry\n
oc get pod -n openshift-image-registry -l docker-registry=default -o jsonpath='{.items[0].spec.containers[0].env}' | jq\n