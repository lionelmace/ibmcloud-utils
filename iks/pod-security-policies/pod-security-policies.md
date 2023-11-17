Source: https://samos-it.com/posts/Preventing-Privileged-pods-using-Pod-Security-Admission-Standards.html

```sh
kubectl label --dry-run=server --overwrite ns default \
    pod-security.kubernetes.io/enforce=baseline
```

Assuming you had no warnings. Let's start by enforcing the baseline standard on the default namespace:

```sh
kubectl label --overwrite ns default \
    pod-security.kubernetes.io/enforce=baseline
```

```sh
kubectl apply -f nginx-priv.yaml
```
