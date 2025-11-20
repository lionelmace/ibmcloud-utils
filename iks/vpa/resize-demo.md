# [In-place resource resize for vertical scaling of Pods](https://kubernetes.io/blog/2025/04/23/kubernetes-v1-33-release/#beta-in-place-resource-resize-for-vertical-scaling-of-pods)

1. Create demo pod

    ```sh
    kubectl apply -f - <<EOF
    apiVersion: v1
    kind: Pod
    metadata:
      name: resize-demo
    spec:
      containers:
      - name: demo-container
        image: busybox
        command: ["sleep", "3600"]
        resources:
          requests:
            cpu: "100m"
            memory: "128Mi"
          limits:
            cpu: "200m"
            memory: "256Mi"
    EOF
    ```

1. Check the cpu/memory requests and limits.

    ```sh
    kubectl get pod resize-demo -o jsonpath='{.spec.containers[*].resources}' | jq .
    ```

1. Resize the requests and limits in-place (requires kubectl v1.32+).

    ```sh
    kubectl patch pod resize-demo --subresource=resize --type=merge -p '{
      "spec": {
        "containers": [{
          "name": "demo-container",
          "resources": {
            "requests": {
              "cpu": "500m",
              "memory": "512Mi"
            },
            "limits": {
              "cpu": "1",
              "memory": "1Gi"
            }
          }
        }]
      }
    }'
    ```

1. Verify requests and limits have been updated in-place.

    ```sh
    kubectl get pod resize-demo -o jsonpath='{.spec.containers[*].resources}' | jq .
    ```

1. Verify the pod has not been restarted.

    ```sh
    kubectl get pod resize-demo
    ```

1. Clean up.

    ```sh
    kubectl delete pod resize-demo
    ```
