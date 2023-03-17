# Deployment of a VNET to act as spoke of a Fortigate Cluster deployment on the Azure with Terraform
## Introduction

This module IaC is a part of a full deployment of a Fortigate cluster in a sandwich configuration. This terraform code will deploy spoke VNETs with preconfigured subnets: subnet-1, subnet-2, GatewaySubnet, RouterServer, PrivateLinkSubnet, PrivateLinkServicesSubnet. Network Security Groups and interfaces in subnet-1 y subnet-2 of each VNET are also created, for attached to future test VM deployed in those subnets.

## Requirements
* [Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html) >= 0.12.0
* Terraform Provider AzureRM >= 2.24.0
* Terraform Provider Template >= 2.2.0
* Terraform Provider Random >= 3.1.0


## Deployment overview
Terraform deploys the following components:
   - Update vars.tf with CIDR blocks for each VNET you want to deploy

## Deployment considerations:
   - Create file terraform.tfvars using terraform.tfvars.example as template 
   - Update variables in var.tf with fortigate cluster deployment
   - You will be charged for this deployment

## Deployment
To deploy the FortiGate-VM to Azure:
1. Create module with source `source = "github.com/jmvigueras/modules/azure/vnet-spoke`
2. Customize variables in the `terraform.tfvars.example` and `vars.tf` file as needed.  And rename `terraform.tfvars.example` to `terraform.tfvars`.
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

Output will include the information necessary:
```sh
Outputs:

<Detail info of VNETs and Subnet deployed>
```

## Destroy the deployment
To destroy the instance, use the command:
```sh
$ terraform destroy
```

# Support
This a personal repository with goal of testing and demo Fortinet solutions on the Cloud. No support is provided and must be used by your own responsability. Cloud Providers will charge for this deployments, please take it in count before proceed.

## License
Based on Fortinet repositories with original [License](https://github.com/fortinet/fortigate-terraform-deploy/blob/master/LICENSE) © Fortinet Technologies. All rights reserved.

