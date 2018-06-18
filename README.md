# Terraform template for Angular SPA Application

## How to use

1. create a `infra/main.tf` in your project root directory. Replace the `aws.profile` and `spa.hosted_zone`

    ```terraform
    # main.tf

    provider "aws" {
        region  = "us-east-1"
        profile = "chyngeAdmin"
    }

    module "spa" {
        source        = "github.com/bagubagu/terraform-spa"
        hosted_zone   = "chynge.com"
        force_destroy = true
    }
    ```

1. Init and run terraform apply from the `infra` directory

    ```bash
    cd infra
    terraform init
    terraform apply
    ```

