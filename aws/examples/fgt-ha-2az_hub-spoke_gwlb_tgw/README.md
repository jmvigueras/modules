# Forigate cluster deployment in 2 AZ with 1 cluster as SDWAN spoke other as HUB
## Introduction

This deployment will establish a comprehensive SDWAN environment consisting of a HUB and a spoke. The spoke will consist of an active-active Fortigate Cluster (FGSP) deployed within a Virtual Private Cloud (VPC), where traffic will be forwarded from the VPC spoke to a Transit Gateway (TGW). The cluster will serve as the backend for a Gateway Load Balancer (GWLB), and endpoints will be deployed in the VPC to handle traffic from the TGW. The HUB cluster will be deployed in a separate VPC, configured as an FGCP cluster, and IPSEC tunnels will be established over the Internet.

## Deployment Overview

- New VPCs for cluster HUB and SPOKE with subnets in each AZ: Management (MGMT), Public, Private, Bastion, TGW and GWLB.
- New VPCs spokes attached to TGW
- Fortigate cluster HUB (FGCP): 2 instances with 3 insterfaces each one and 2 EIP for management associated to MGMT interface and 1 EIP associated to active public interface.
- Fortigate cluster SPOKE (FGSP): 2 instances with 3 insterfaces acting as backend of a GWLB using private port to stablish GENEVE tunnels
- VM linux instances for testing in TGW VPC spokes and in HUB VPC. 

## Diagram overview

![FortiGate reference architecture overview](images/image1.png)

## Requirements
* [Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html) >= 1.0.0
* Check particulars requiriments for each deployment (AWS) 

## Deployment
* Clone the repository.
* Configure accesss secrets to access AWS in terraform.tfvars.example which is allocated in root folder. [terraform.tfvars.example](./terraform.tfvars.example).  And rename `terraform.tfvars.example` to `terraform.tfvars`.
* Change parameters in the variables.tf.
* If using SSO, uncomment the token variable in variables.tf and providers.tf
* Initialize the providers and modules in each individual deployment as is described in it README file.

# Support
This a personal repository with goal of testing and demo Fortinet solutions on the Cloud. No support is provided and must be used by your own responsability. Cloud Providers will charge for this deployments, please take it in count before proceed.

## License
[License](./LICENSE)

