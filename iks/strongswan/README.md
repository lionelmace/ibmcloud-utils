# Configuring the strongSwan Helm chart

## Configuration

* IKS cluster version `1.29.4_1535`
* Classic Infrastructure
* Datacenter: ams03
* 2 workers each `b3c.4x16`

## Steps

```sh
helm repo add iks-charts https://private.icr.io/helm/iks-charts
```

```sh
helm repo update
```

```sh
helm search repo iks-charts
```

```sh
helm install vpn iks-charts/strongswan -f config.yaml
```

```
NAME: vpn
LAST DEPLOYED: Mon May  6 16:50:51 2024
NAMESPACE: default
STATUS: deployed
REVISION: 1
NOTES:
Thank you for installing: strongswan.   Your release is named: vpn

1. Wait for the strongswan pod to go to a "Running" state:

    kubectl get pod -wn default -l app=strongswan,release=vpn

2. To check the status of the VPN connection:

    export STRONGSWAN_POD=$(kubectl get pod -n default -l app=strongswan,release=vpn -o jsonpath='{ .items[0].metadata.name }')

    kubectl exec -n default  $STRONGSWAN_POD -- sudo ipsec status
    kubectl logs -n default  $STRONGSWAN_POD
```

Output for a Tunnel UP

```sh
kubectl exec -n default  $STRONGSWAN_POD -- sudo ipsec status
Shunted Connections:
Bypass LAN 169.254.1.1/32:  169.254.1.1/32 === 169.254.1.1/32 PASS
Bypass LAN fe80::/64:  fe80::/64 === fe80::/64 PASS
Security Associations (1 up, 0 connecting):
    k8s-conn[2]: ESTABLISHED 4 minutes ago, 172.30.234.209[ibm-cloud]...10.137.85.26[on-prem]
    k8s-conn{1}:  INSTALLED, TUNNEL, reqid 1, ESP in UDP SPIs: cd8c72eb_i c12bd10a_o
    k8s-conn{1}:   172.21.0.0/16 === 192.168.0.0/20
```

```sh
kubectl delete pods -l app=strongswan
```

## Resources

https://cloud.ibm.com/docs/containers?topic=containers-vpn#vpn_configure
