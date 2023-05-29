# List of modules for GCP deployments
## Introduction

This is a collection of modules for GCP deployments. You can find an example of how to use each module in example folder. 

## List of modules
      - module faz (`github.com/jmvigueras/modules//gcp/faz`)
      - module fgt-config (`github.com/jmvigueras/modules//gcp/fgt-config`)
      - module fgt-ha (`github.com/jmvigueras/modules//gcp/fgt-ha`)
      - module fgt-ha_ips-fwr (`github.com/jmvigueras/modules//gcp/fgt-ha_ips-fwr`)
      - module fmg (`github.com/jmvigueras/modules//gcp/fmg`)
      - module ncc (`github.com/jmvigueras/modules//gcp/ncc`)
      - module new-instance (`github.com/jmvigueras/modules//gcp/new-instance`)
      - module proxy (`github.com/jmvigueras/modules//gcp/proxy`)  
      - module vpc-fgt (`github.com/jmvigueras/modules//gcp/vpc-fgt`)
      - module vpc-spoke (`github.com/jmvigueras/modules//gcp/vpc-spoke`)
      - module xlb (`github.com/jmvigueras/modules//gcp/xlb`)
      
## Deployment considerations:
   - Create file terraform.tfvars using terraform.tfvars.example as template 
   - Update variables in var.tf with fortigate cluster deployment
   - You will be charged for this deployment

## Requirements
* [Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html) >= 0.12.0
* Check particulars requiriments for each deployment (GCP) 

# Support
This a personal repository with goal of testing and demo Fortinet solutions on the Cloud. No support is provided and must be used by your own responsability. Cloud Providers will charge for this deployments, please take it in count before proceed.

## License
[License](./LICENSE)

