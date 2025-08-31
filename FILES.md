# 📂 EKS-Setup

This is your Terraform project folder. All Terraform code for provisioning AWS EKS lives here.

1. .terraform/

- Type: Hidden directory (auto-created by Terraform)

- Purpose: Stores Terraform’s plugin binaries and module cache.

- Details:

    - When you run terraform init, Terraform downloads necessary providers (like AWS, Docker, Kubernetes, etc ) into this directory.
    - You never edit this manually.
    - Should be ignored in Git because it’s environment-specific.

2. terraform.lock.hcl

- Type: Lock file

- Purpose: Keeps track of exact provider versions used.

- Details:

    - It’s a dependency lock file, created automatically by Terraform when you run terraform init.
    - It locks the versions of all providers and their dependencies (like AWS, Kubernetes, Helm providers) so your infrastructure setup is consistent across machines and teams.
    - Ensures everyone uses the same provider version, avoiding breaking changes.

3. backend.tf

- Type: Terraform configuration file for remote state backend

- Purpose: Defines where and how Terraform state is stored.

- Details:

    - If you’re using AWS S3 + DynamoDB, you’ll configure it here.
    - This ensures team collaboration and prevents conflicting state changes.

4. main.tf

- Type: Core configuration file

- Purpose: Defines resources (VPC, Subnets, EKS Cluster, Nodes, etc.).

- Details:

    - This is the heart of your Terraform project.
    - Example:

        ```hcl
        resource "aws_eks_cluster" "eks" {
        name     = var.cluster_name
        role_arn = aws_iam_role.eks_role.arn
        vpc_config {
            subnet_ids = var.subnet_ids
        }
        }
        ```

    - You can split this into multiple files (vpc.tf, eks.tf, etc.).

5. output.tf

- Type: Output configuration file

- Purpose: Defines what Terraform should display after applying changes.

- Details:

    - Useful for showing important values like the cluster endpoint, kubeconfig, or IAM roles.

    - Example:

        ```hcl
        output "cluster_endpoint" {
        value = aws_eks_cluster.eks.endpoint
        }
        ```

6. provider.tf

- Type: Provider configuration file

- Purpose: Configures Terraform providers (AWS, Kubernetes, Helm, etc.).

- Details:

    - This tells Terraform which cloud/API to use.

    - Example:

        ```hcl
        provider "aws" {
        region  = var.aws_region
        profile = var.aws_profile
        }
        ```

7. terraform.tfstate

- Type: State file (auto-generated)

- Purpose: Stores the current state of your infrastructure.

- Details:

    - This file represents what Terraform thinks exists in your AWS environment.
    - It’s critical for Terraform to know what resources to create, update, or destroy.
    - Never manually edit this file.

8. terraform.tfstate.backup

- Type: Backup state file (auto-generated)

- Purpose: A backup of the previous state before Terraform makes changes.

- Details:

    - Helps with state recovery if something goes wrong.
    - Also not meant for manual editing.

9. terraform.tfvars

- Type: Variables file

- Purpose: Stores actual values for the variables defined in variables.tf.

- Details:

    - Keeps secrets and environment-specific values (like cluster name, region).

    - Example:

        ```hcl
        cluster_name = "my-eks-cluster"
        aws_region   = "us-east-1"
        ```


10. variables.tf

- Type: Variable definitions file

- Purpose: Declares variables that can be reused across Terraform files.

- Details:

    - You define variables once and use them everywhere.

    - Example:
        ```hcl
        variable "aws_region" {
        description = "AWS region to deploy resources"
        type        = string
        default     = "us-east-1"
        }
        ```



