# Terraform SPA template

Build infrastructure for Angular based SPA.

## How to use

1.  create a `infra/main.tf` in your project root directory. Replace the `aws.profile` and `spa.hosted_zone`

    ```terraform
    # main.tf

    provider "aws" {
        region  = "us-east-1"
        profile = "exampleAdmin"
    }

    module "spa" {
        source        = "github.com/bagubagu/terraform-spa"
        hosted_zone   = "example.com"
        force_destroy = true
    }
    ```

1.  Init and run terraform apply from the `infra` directory

    ```bash
    cd infra
    terraform init
    terraform apply
    ```

1.  Bob's your uncle.

## What does this do?

If hosted_zone is `example_com`:

- Setup s3 originbucket `example-com-origin`
- Setup s3 cloudformation log bucket `example-com-cloudfront-log`
- Add apex and www records to DNS
- Setup cloudfront with alias `example.com` and `www.example.com`
- Configure cloudfront to use lambda@edges
- Create ACM certificate `example.com` and `*.example.com`
- Setup all corresponding IAM users, groups, policies, and roles

### Lambda@Edge Features

- Return correct `stellar.toml` headers
- Return everyting in '/assets' as is
- Request for uri without extension gets redirected to `/index.html`
- Redirect errors (4xx and 5xx) to `/index.html`
- Easter egg

## FAQ

1.  I got following error

    ```
    Error: Error applying plan:

    1 error(s) occurred:

    * module.spa.aws_cloudfront_distribution.origin: 1 error(s) occurred:

    * aws_cloudfront_distribution.origin: error creating CloudFront Distribution: InvalidViewerCertificate: The specified SSL certificate doesn't exist, isn't in us-east-1 region, isn't valid, or doesn't include a valid certificate chain.
        status code: 400, request id: 68fae058-72bc-11e8-a266-5d955149d452
    ```


    __Answer:__

    Just run `terraform apply` again and you'll be fine. It is caused by a bug in terraform cloudfront_distribution template.
