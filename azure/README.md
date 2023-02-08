# List of modules for Azure deployments
## Introduction

This is a collection of modules for Azure deployments. You can find an example of how to use each module in example folder. 

## Requirements
* [Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html) >= 0.12.0
* Terraform Provider AzureRM >= 2.24.0
* Terraform Provider Template >= 2.2.0
* Terraform Provider Random >= 3.1.0

## List of modules
      - module fgt-ha-xlb-hub-sdwan-vwan (`github.com/jmvigueras/modules//azure/fgt-ha-xlb-hub-sdwan-vwan`)
      - module vwan (`github.com/jmvigueras/modules//azure/vwan`)
      - module vnet-fgt (`github.com/jmvigueras/modules//azure/vnet-fgt`)
      - module vnet-spoke (`github.com/jmvigueras/modules//azure/vnet-spoke`)
      - module site-spoke-to-2hubs (`github.com/jmvigueras/modules//azure/site-spoke-to-2hubs`)
      - module xlb-fgt (`github.com/jmvigueras/modules/azure//xlb-fgt`)
      - module rs (`github.com/jmvigueras/modules//azure/rs`)


## Deployment considerations:
   - Create file terraform.tfvars using terraform.tfvars.example as template 
   - Update variables in var.tf with fortigate cluster deployment
   - You will be charged for this deployment


# Support
This a personal repository with goal of testing and demo Fortinet solutions on the Cloud. No support is provided and must be used by your own responsability. Cloud Providers will charge for this deployments, please take it in count before proceed.

## License
Based on Fortinet repositories with original [License](https://github.com/fortinet/fortigate-terraform-deploy/blob/master/LICENSE) © Fortinet Technologies. All rights reserved.

