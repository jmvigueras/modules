# Deployment of FortiGate-VM (PAYG/BYOL) Cluster on the AWS with 3 ports
## Introduction
A Terraform script to deploy a standalone FortiGate-VM on AWS with 3 ports 

## Requirements
* [Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html) >= 1.0.9
* Terraform Provider AWS 3.63.0
* Terraform Provider Template 2.2.0
* Needs to have FOS v7.0 later that supports the hasync/hamgmt single port feature.


## Deployment overview
Terraform deploys the following components:
   - A AWS VPC with 4 subnets in one AZ (Public, Private, MGMT and Servers)
   - One FortiGate-VM (PAYG) instance with three NICs. (port1 - mgmt, port2 - public, port3 - private).
   - Four Network Security Group rules: external fortigate interface, one for internal and management and other for servers.
   - 3 network interfaces for Fortigate
   - 1 network interface for test Server

## Deployment
To deploy the FortiGate-VM to AWS:
1. Clone the repository.
2. Customize variables in the `terraform.tfvars.example` and `variables.tf` file as needed.  And rename `terraform.tfvars.example` to `terraform.tfvars`.
3. Initialize the providers and modules:
   ```sh
   $ cd XXXXX
   $ terraform init
    ```
4. Submit the Terraform plan:
   ```sh
   $ terraform plan
   ```
5. Verify output.
6. Confirm and apply the plan:
   ```sh
   $ terraform apply
   ```
7. If output is satisfactory, type `yes`.

Output will include the information necessary to log in to the FortiGate-VM instances:
```sh
Outputs:

url           = https://fgt_mgmt_IP:admin_port
ip            = <fgt management public IP>
admin_port    = <admin port>
api-token     = <generated random API token>
username      = <admin>
password      = <defaul password fgt instance id>

```

## Destroy the instance
To destroy the instance, use the command:
```sh
$ terraform destroy
```

# Support
This a personal repository with goal of testing and demo Fortinet solutions on the Cloud. No support is provided and must be used by your own responsability. Cloud Providers will charge for this deployments, soy take it in count before proceed.

## License
Based on Fortinet repositories with original [License](https://github.com/fortinet/fortigate-terraform-deploy/blob/master/LICENSE) © Fortinet Technologies. All rights reserved.
