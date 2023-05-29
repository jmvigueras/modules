# List of modules for AWS deployments
## Introduction

This is a collection of modules for AWS deployments. You can find an example of how to use each module in example folder. 

## List of modules
      - module faz (`github.com/jmvigueras/modules//aws/faz`)
      - module fgt-config (`github.com/jmvigueras/modules//aws/fgt-config`)
      - module fgt-ha (`github.com/jmvigueras/modules//aws/fgt-ha`)
      - module fgt-ha_ni-nsg (`github.com/jmvigueras/modules//aws/fgt-ha_ni-nsg`)
      - module fgt-ha-1az (`github.com/jmvigueras/modules//aws/fgt-ha-1az`)
      - module fgt-standalone-2az-gwlb (`github.com/jmvigueras/modules/aws/fgt-standalone-2az-gwlb`)
      - module fmg (`github.com/jmvigueras/modules//aws/fmg`)
      - module gwlb (`github.com/jmvigueras/modules//aws/gwlb`)
      - module new-instance (`github.com/jmvigueras/modules//aws/new-instance`)
      - module new-instance_ni (`github.com/jmvigueras/modules//aws/new-instance_ni`)
      - module tgw (`github.com/jmvigueras/modules//aws/tgw`)
      - module tgw_connect (`github.com/jmvigueras/modules//aws/tgw_connect`)
      - module vpc-fgt-1az (`github.com/jmvigueras/modules//aws/vpc-fgt-1az`)
      - module vpc-fgt-2az_tgw-gwlb (`github.com/jmvigueras/modules//aws/vpc-fgt-2az_tgw-gwlb`)
      - module vpc-fgt-2az_to-fgt (`github.com/jmvigueras/modules//aws/vpc-fgt-2az_to-fgt`)
      - module vpc-fgt-2az_to-tgw (`github.com/jmvigueras/modules//aws/vpc-fgt-2az_to-tgw`)

## Deployment considerations:
   - Create file terraform.tfvars using terraform.tfvars.example as template 
   - Update variables in var.tf with fortigate cluster deployment
   - You will be charged for this deployment

## Requirements
* [Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html) >= 1.0.0
* Check particulars requiriments for each deployment (AWS) 

# Support
This a personal repository with goal of testing and demo Fortinet solutions on the Cloud. No support is provided and must be used by your own responsability. Cloud Providers will charge for this deployments, please take it in count before proceed.

## License
[License](./LICENSE)

