# aws_lab

## To setup the lab

Configure your credentials into `~/.aws/config`.  
It should look like this (you can add each profile): 

```
[profile name_of_the_profile]
aws_access_key_id=XXXXX
aws_secret_access_key=XXXXX
aws_session_token=XXXXX
```

## To run the lab

```
terraform init
terraform plan
terraform apply
```

To change the value of the deployment check this [file](terraform.tfvars)



---
Inspirated on : https://github.com/freight-hub/terraform-modules-demo/blob/main/terraform-google-network/main.tf