Certificate to be used in Cloud Foundry

# Generate certificate with Let's encrypt

1. Install Let's Encrypt
    ```
    brew install letsencrypt
    ```

1. Generate a signed certificate for **secure.lionelmace.com
    ```
    sudo certbot certonly --manual --preferred-challenges=dns --server https://acme-v02.api.letsencrypt.org/directory -d '*.secure.lionelmace.com'
    ```

1. Check the generate certificates
    ```
    sudo ls /etc/letsencrypt/live/secure.lionelmace.com/
    ```
    Output:
    ```
    README		cert.pem	chain.pem	fullchain.pem	privkey.pem
    ```

1. Copy the certificate and key in a Read directory to be able to load them from Cloud Foundry
    ```
    sudo cp /etc/letsencrypt/live/secure.lionelmace.com/fullchain.pem mydemo/certificate/.
    sudo cp /etc/letsencrypt/live/secure.lionelmace.com/privkey.pem mydemo/certificate/.
    chmod 644 fullchain.pem
    chmod 644 privkey.pem
    ```

# Resources
* [Let's encrypt](https://certbot.eff.org/lets-encrypt/osx-other)