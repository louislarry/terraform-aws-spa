# Terraform template for Angular SPA Application

## How to use

1. create a `infra/main.tf` in your project root directory

    Write main.tf as follows. Replace the `hosted_zone`.

    ```json

    module "spa" {
    source        = "github.com/bagubagu/terraform-spa"
    hosted_zone   = "chynge.com"
    force_destroy = true
    }
    ```

1. Init and run terraform apply from the `infra` directory

    ```bash
    terraform init
    terraform apply
    ```

