#!/bin/bash

echo "Terraform destroy"
terraform destroy 

echo "cleaning lock.hcl file"
rm .terraform.lock.hcl

echo "cleaning .terraform folder"
rm -fr .terraform

echo "cleaning state file"
rm *.tfstate *.tfstate.backup 
rm -fr  terraform.tfstate.d

echo "cleaning log"
rm *.log