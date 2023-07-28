# List of modules for OCI deployments
## Introduction

This is a collection of modules for OCI deployments. You can find an example of how to use each module in example folder. 

## List of modules
      - module fgt_config (`github.com/jmvigueras/modules//oci/fgt_config`)
      - module fgt_ha (`github.com/jmvigueras/modules//oci/fgt_ha`)
      - module instance (`github.com/jmvigueras/modules//oci/instance`) 
      - module vcn_fgt (`github.com/jmvigueras/modules//oci/vcn_fgt`)
      - module vcn_spoke_drg (`github.com/jmvigueras/modules//oci/vcn_spoke_drg`)
      - module vcn_spoke_peer (`github.com/jmvigueras/modules//oci/vcn_spoke_peer`)
      
## Deployment considerations:
   - Create file terraform.tfvars using terraform.tfvars.example as template 
   - Update variables in var.tf with fortigate cluster deployment
   - You will be charged for this deployment

## Requirements
* [Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html) >= 0.12.0
* Check particulars requiriments for each deployment (OCI) 

# Support
This a personal repository with goal of testing and demo Fortinet solutions on the Cloud. No support is provided and must be used by your own responsability. Cloud Providers will charge for this deployments, please take it in count before proceed.

## License
[License](./LICENSE)

