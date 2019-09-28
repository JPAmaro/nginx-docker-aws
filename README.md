# nginx-docker-aws
Summary:

Terraform was used to launch a cluster of EC2 instances. Each EC2 instance runs a nginx docker container in each availability zone. The load balancer and EC2 instances are launched in a custom VPC.

Autoscaling is triggered by a policy that compares CPU utilization. If average CPU utilization is higher than 60% or lower than 50% for 2 consecutive periods then a new instance is created.

Command Line:

  -Setup:
    terraform init

  -Launch EC2 cluster:
    terraform plan -out=aws.tfplan
    terraform apply aws.tfplan

Notes:

AWS access credentials must be supplied to Terraform in "~/.aws/credentials" file. The scripts were tested with my AWS account with a user that has full admin policy.

After applying the Terraform configuration it returns the load balancer's public URL in the output to view the default nginx homepage.
