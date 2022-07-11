# Deploy NLB (Network Load Balancer) with ROKS

1. Deploy a service with NLB

    ```sh
    oc apply -f nlb-udp.yaml
    ```

1. Check the status of your service.

    ```sh
    oc describe service nlb-udp
    ```

    > It takes a few minutes for the the Load Balancer to be provisioning. 

1. You can check the status in the [console](https://cloud.ibm.com/vpc-ext/network/loadBalancers)

1. You can also see the list of VPC Load Balancers using the CLI

    ```sh
    ibmcloud is lbs
    ```

1. Get details about the NLB

    ```sh
    ibmcloud is lb <your-nlb-id>
    ```

1. Noticed the last line that says UDP supported

    ```sh
    Getting load balancer r018-b99b0247-5a9d-40bf-8ff2-c6d7a8350118 under account CPL@fr ibm com's Account as user lionel.mace@fr.ibm.com...

    ID                          r018-b99b0247-5a9d-40bf-8ff2-c6d7a8350118
    Name                        kube-cb1gbg4l0mttfdmegt50-6334c0ea400147b5bf44c499d47e06e7
    CRN                         crn:v1:bluemix:public:is:eu-gb-2:a/c7ab6a05ec1e3eb13f5e81aa302bdbd0::load-balancer:r018-b99b0247-5a9d-40bf-8ff2-c6d7a8350118
    Family                      Network
    Host name                   b99b0247-eu-gb.lb.appdomain.cloud
    Subnets                     ID                                          Name
                                0797-91785612-96be-48eb-a42b-448c79975ef7   sn-20220617-02

    Public IPs                  141.125.160.250
    Reserved IPs                ID                                          Address        Subnet
                                0797-ea9fa409-89c5-4ab6-a5a1-e6399ed828dd   10.242.64.25   0797-91785612-96be-48eb-a42b-448c79975ef7
                                0797-341da38a-e4e0-4207-8094-69c6e12f4844   10.242.64.26   0797-91785612-96be-48eb-a42b-448c79975ef7

    Provision status            active
    Operating status            online
    Is public                   true
    Listeners                   r018-defac80c-8c3e-49cf-a63b-8c6d6d3e5333
    Pools                       ID                                          Name
                                r018-f9f2fc6d-65c3-4b3d-8806-33130de6094d   tcp-8080-30263

    Resource group              ID                                 Name
                                5fac4d154daa483e8dfb76eef75b31e4   DS-NuoDB

    Created                     2022-07-08T18:24:50+02:00
    Security groups supported   false
    UDP Supported               true
    ```

## Resources

* [Setting up a Network Load Balancer for VPC](https://cloud.ibm.com/docs/containers?topic=containers-vpc-lbaas#nlb_vpc)
