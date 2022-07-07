# Deploy NLB with ROKS


```
ic is lb r018-807ed99f-7a89-496a-a251-75ac1f20c385
```

```
Getting load balancer r018-807ed99f-7a89-496a-a251-75ac1f20c385 under account CPL@fr ibm com's Account as user lionel.mace@fr.ibm.com...

ID                          r018-807ed99f-7a89-496a-a251-75ac1f20c385
Name                        ds-nuodb-nlb
CRN                         crn:v1:bluemix:public:is:eu-gb-2:a/c7ab6a05ec1e3eb13f5e81aa302bdbd0::load-balancer:r018-807ed99f-7a89-496a-a251-75ac1f20c385
Family                      Network
Host name                   807ed99f-eu-gb.lb.appdomain.cloud
Subnets                     ID                                          Name
                            0797-91785612-96be-48eb-a42b-448c79975ef7   sn-20220617-02

Public IPs                  141.125.104.119
Reserved IPs                ID                                          Address        Subnet
                            0797-762f371b-3ce5-4889-ac1d-899ae376812b   10.242.64.21   0797-91785612-96be-48eb-a42b-448c79975ef7
                            0797-92414ea6-644d-4630-9aa7-79fc56965d6e   10.242.64.22   0797-91785612-96be-48eb-a42b-448c79975ef7

Provision status            active
Operating status            online
Is public                   true
Listeners                   r018-a91d9bf9-e1b0-4630-be38-0e6e878ebc0e
Pools                       ID                                          Name
                            r018-40dd559d-1cc4-46b3-9365-df98eb17c6ba   udp

Resource group              ID                                 Name
                            5fac4d154daa483e8dfb76eef75b31e4   DS-NuoDB

Created                     2022-07-07T14:13:39+02:00
Security groups supported   false
UDP Supported               true
```

```
ic is lb-pmc r018-807ed99f-7a89-496a-a251-75ac1f20c385 r018-40dd559d-1cc4-46b3-9365-df98eb17c6ba 4500 kube-cb1gbg4l0mttfdmegt50-dsnuodbclus-default-0000021f
```
```
Error
Creating member of pool r018-40dd559d-1cc4-46b3-9365-df98eb17c6ba under account CPL@fr ibm com's Account as user lionel.mace@fr.ibm.com...
FAILED
Failed to create member.

FAILED
Response HTTP Status Code: 404
Error code: member_not_found
Error message: Member with ID 'kube-cb1gbg4l0mttfdmegt50-dsnuodbclus-default-0000021f' cannot be found.
Error target name: member.id, type: field
More information: https://cloud.ibm.com/docs/vpc?topic=vpc-rias-error-messagesmember_not_found
Trace ID: 32f8f1a9-203b-423f-b66d-9dd575a260c0
```