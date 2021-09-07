# VPN

![VPN](./vpn-ui.png)

## Generating certificates

1. Clone the Easy-RSA 3 repository into your local folder:

    ```sh
    git clone https://github.com/OpenVPN/easy-rsa.git
    cd easy-rsa/easyrsa3
    ```

1. Create a new PKI and CA:

    ```sh
    ./easyrsa init-pki
    ./easyrsa build-ca nopass
    ```

1. Generate a VPN server certificate.

    ```sh
    ./easyrsa build-server-full vpn-server.vpn.ibm.com nopass
    ```

1. Generate a VPN client certificate.

    ```sh
    ./easyrsa build-client-full client1.vpn.ibm.com nopass
    ```

## Importing a certificate into the certificate manager

1. Create an instance of `Certificate Manager`

    ```sh
    ibmcloud resource service-instance-create <service-name> cloudcerts "free" <region>
    ```

1. Import the certificates into this instance

    ![Certificate Manager](./cert-mgr.png)

## Create a VPN

1. Go the [VPN Gateways](https://cloud.ibm.com/vpc-ext/network/vpnServers).

1. Enter Client IPv4 address pool `192.168.4.0/22`

    > This range must be different from your local range and IBM Cloud IP ranges.

1. Make sure to select the `Split Tunnel` option at the bottom of the form

    > Split tunnel: Private traffic flows through the VPN interface to the VPN tunnel, and public traffic flows through the existing LAN interface.

1. Note the Transport protocol `UDP` and `VPN port` 443. You will add an inbound rule with those values in the Security Group.

## Update your Install local VPN

1. Download client profile from the VPN you created. You should have a .ovpn file.

1. Edit the .ovpn file and update the last two lines to reflect you client public and private keys

## Install local VPN

1. Install Tunnelblick from the [Downloads](https://tunnelblick.net/downloads.html).

1. Import the .ovpn in the Configurations panel.

1. Click `Connect`.

## Errors

1. TLS Error: TLS handshake failed

    ```sh
    2021-09-07 15:39:15.949622 TLS Error: TLS key negotiation failed to occur within 60 seconds (check your network connectivity)
    2021-09-07 15:39:15.949726 TLS Error: TLS handshake failed
    ```

    >> Update your VPC Security Groups