# nginx-docker-aws
**Summary:**

Terraform was used to launch a cluster of EC2 instances. Each EC2 instance runs a nginx docker container in each availability zone. The load balancer and EC2 instances are launched in a custom VPC.

Autoscaling is triggered by a policy that compares CPU utilization. If average CPU utilization is higher than 60% or lower than 50% for 2 consecutive periods then a new instance is created.

**Command Line:**

Setup:
$ terraform init

Launch EC2 cluster:
$ terraform plan -out=aws.tfplan
$ terraform apply aws.tfplan

Teardown EC2 cluster:
$ terraform destroy

**Notes:**

AWS access credentials must be supplied at run time or, if created beforehand, Terraform can get the values from environment variables, that must be exported like this:
export TF_VAR_aws_region=us-east-1
export TF_VAR_aws_access_key=abc123
export TF_VAR_aws_secret_key=def123

The scripts were tested with my AWS account with a user that has full admin policy.

After applying the Terraform configuration it returns the load balancer's public URL in the output to view the default nginx homepage.
