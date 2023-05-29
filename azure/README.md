# List of modules for Azure deployments
## Introduction

This is a collection of modules for Azure deployments. You can find an example of how to use each module in example folder. 

## List of modules
      - module faz (`github.com/jmvigueras/modules//azure/faz`)
      - module fgt-config (`github.com/jmvigueras/modules//azure/fgt-config`)
      - module fgt-config_4ports (`github.com/jmvigueras/modules//azure/fgt-config_4ports`)
      - module fgt-config_v2 (`github.com/jmvigueras/modules//azure/fgt-config_v2`)
      - module fgt-ha (`github.com/jmvigueras/modules//azure/fgt-ha`)
      - module fgt-ha_4ports (`github.com/jmvigueras/modules//azure/fgt-ha_4ports`)
      - module fgt-ha_ni-nsg (`github.com/jmvigueras/modules//azure/fgt-ha_ni-nsg`)
      - module fmg (`github.com/jmvigueras/modules//azure/fmg`)
      - module new-vm (`github.com/jmvigueras/modules//azure/new-vm`)
      - module new-vm_rsa-ssh (`github.com/jmvigueras/modules//azure/new-vm_rsa-ssh`)
      - module new-vm_rsa-ssh_v2 (`github.com/jmvigueras/modules//azure/new-vm_rsa-ssh_v2`)
      - module routeserver (`github.com/jmvigueras/modules//azure/routeserver`)  
      - module vnet-fgt (`github.com/jmvigueras/modules//azure/vnet-fgt`)
      - module vnet-fgt_4ports (`github.com/jmvigueras/modules//azure/vnet-fgt_4ports`)
      - module vnet-spoke (`github.com/jmvigueras/modules//azure/vnet-spoke`)
      - module vnet-spoke_v2 (`github.com/jmvigueras/modules//azure/vnet-spoke_v2`)
      - module vwan (`github.com/jmvigueras/modules//azure/vwan`)
      - module xlb (`github.com/jmvigueras/modules//azure/xlb`)
      
## Deployment considerations:
   - Create file terraform.tfvars using terraform.tfvars.example as template 
   - Update variables in var.tf with fortigate cluster deployment
   - You will be charged for this deployment

## Requirements
* [Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html) >= 0.12.0
* Terraform Provider AzureRM >= 2.24.0
* Terraform Provider Template >= 2.2.0
* Terraform Provider Random >= 3.1.0

# Support
This a personal repository with goal of testing and demo Fortinet solutions on the Cloud. No support is provided and must be used by your own responsability. Cloud Providers will charge for this deployments, please take it in count before proceed.

## License
[License](./LICENSE)

