To use the Private Ingress Controller, we need to activate the ALB (Automatic Load Balancer).


## Use Private Ingress Controler

1. To get the **ALB-ID** and its IP address:

    ```
    bx cs albs --cluster <cluster-name>
    ```

    ```
    ALB ID                                            Enabled   Status    Type      ALB IP   
    private-crc787582007c543f9b03e1656727e263d-alb1   true      enabled   private   10.135.30.246   
    public-crc787582007c543f9b03e1656727e263d-alb1    true      enabled   public    159.122.83.190
    ```

1. Then, activate the **Application Load Balancer** ALB

  bx cs alb-configure --albID public-crc787582007c543f9b03e1656727e263d-alb1 --enable

1. The applications are now available on the private IP address. In this case, via [http://10.135.30.246](http://10.135.30.246)

1. Make sure to the ALB in the yml deployment file

    ```yml
    apiVersion: extensions/v1beta1
    kind: Ingress
    metadata:
      name: poc2-private
      annotations:
        ingress.bluemix.net/ALB-ID: private-crc787582007c543f9b03e1656727e263d-alb1
    spec:
      rules:
      - host: www.poc2-private.com
        http:
          paths:
          - path: /openam
            backend:
              serviceName: openam
              servicePort: 8080
          - path: /
            backend:
              serviceName: administration
              servicePort: 8080
    ```


## Resources

- [Doc on how to privately expose apps using a custom domain without TLS](https://console.bluemix.net/docs/containers/cs_ingress.html#private_ingress_no_tls)
