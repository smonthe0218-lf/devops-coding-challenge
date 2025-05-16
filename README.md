Devops-coding-challenge
This is the terraform repo for the project located at https://github.com/smonthe0218-lf/devops-challenge-lightfeather.

The terraform files will deploy the frontend and backend components and expose the frontend using an application load balancer.

The output will be the DNS name of the application load balancer.

Backend
The backend end state is stored in an existing bucket terraform-bucket-stephan. The bucket is private and encrypted and has versioning enabled, which provides security to the terraform state.

In case there is no existing bucket, one can be easily created using this

resource "aws_s3_bucket" "-bucket" {
  bucket = "devops-terraform-state"

  # Prevent accidental deletion of this S3 bucket
  lifecycle {
    prevent_destroy = false
  }

  # Enable versioning so we can see the full revision history of our
  # state files
  versioning {
    enabled = true
  }

  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}
A dynamo db can also be created to provide state locking using

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "devops-state-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
Networking
The networking components include a VPC with 3 private subnets and 3 public subnets in 3 availability zones in us-east-1 region. We also have an internet gateway, 3 NAT Gateways and 3 EIP, 1 public and private route tables. The application load balancer will sit in the private subnets while the ECS tasks and services will reside in the private subnets for security.

IAM roles
An IAM role is defined to allow ECS to execute tasks.

ALB
An application load balancer will connect to the 2 services using 2 listeners, 1 on 80 with a target group connecting to the frontend ecs service on port 3000. And the other listener will connect to the backend service using port 8080. The ALB and ECS tasks SG have been defined accordingly to enable traffic.

ECS Cluster
An ECS cluster is created along side with 2 log_groups in cloudwatch, 1 for the frontend, 1 for the backend.

Two (2) ECS services are created for the front end and back. They have their respective security groups and they are attached to the ALB created previously with their respective target groups.

Two (2) ECS tasks are created in ecs_tasks.tf, which contain the respective container definition for the frontend container and backend container.

How to run the Terraform script
Inititialize terraform by running

terraform init -backend-config=backend/devops.tf
Then we can validate it by running:

terraform validate
After that run terraform plan

terraform plan -var-file vars/devops.tfvars
Then apply using

   terraform apply -var-file vars/devops.tfvars -auto-approve
Deploying using jenkins
A jenkinsfile was created in this repository https://github.com/smonthe0218-lf/devops-challenge-lightfeather .to allow an end to end deployment of this project.

Use the credentials given to you to log in and run the job using build now.