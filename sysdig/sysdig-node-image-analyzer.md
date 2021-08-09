# Install Node Image Analyser in Sysdig Secure

1. Apply the config map for Sysdig Image Analyzer to the cluster.

    ```sh
    kubectl apply -f sysdig-image-analyzer-configmap.yaml -n ibm-observe
    ```

1. Apply the config map for the Sysdig Host Analyzer to the cluster.

    ```sh
    kubectl apply -f sysdig-host-analyzer-configmap.yaml -n ibm-observe
    ```

1. Apply the config map for the Sysdig Benchmark Runner to the cluster.

    ```sh
    kubectl apply -f sysdig-benchmark-runner-configmap.yaml -n ibm-observe
    ```

1. Apply the daemonset to deploy the Node Analyzer agent to the cluster.

    ```sh
    kubectl apply -f sysdig-node-analyzer-daemonset.yaml -n ibm-observe
    ```

1. At this point, the Node Image analyzer pods should be starting. You can run the following command to confirm the pods are running:

    ```sh
    kubectl get pods -n ibm-observe
    ```

1. 