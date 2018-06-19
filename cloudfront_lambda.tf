# spa/cloudfront_lambda

resource "aws_lambda_function" "rewrite" {
  function_name    = "${local.hosted_zone_dash}-rewrite"
  filename         = "${data.archive_file.rewrite.output_path}"
  source_code_hash = "${data.archive_file.rewrite.output_base64sha256}"
  role             = "${aws_iam_role.lambda_edge.arn}"
  runtime          = "nodejs8.10"
  handler          = "index.handler"
  memory_size      = 128
  timeout          = 3
  publish          = true
}

resource "aws_lambda_function" "add_cors" {
  function_name    = "${local.hosted_zone_dash}-add-cors"
  filename         = "${data.archive_file.add_cors.output_path}"
  source_code_hash = "${data.archive_file.add_cors.output_base64sha256}"
  role             = "${aws_iam_role.lambda_edge.arn}"
  runtime          = "nodejs8.10"
  handler          = "index.handler"
  memory_size      = 128
  timeout          = 3
  publish          = true
}

resource "aws_lambda_function" "origin_response" {
  function_name    = "${local.hosted_zone_dash}-origin-response"
  filename         = "${data.archive_file.origin_response.output_path}"
  source_code_hash = "${data.archive_file.origin_response.output_base64sha256}"
  role             = "${aws_iam_role.lambda_edge.arn}"
  runtime          = "nodejs8.10"
  handler          = "index.handler"
  memory_size      = 128
  timeout          = 3
  publish          = true
}

data "archive_file" "rewrite" {
  type        = "zip"
  source_dir  = "${path.module}/lambda-rewrite/src"
  output_path = "${path.module}/lambda-rewrite.zip"
}

data "archive_file" "add_cors" {
  type        = "zip"
  source_dir  = "${path.module}/lambda-add-cors/src"
  output_path = "${path.module}/lambda-add-cors.zip"
}

data "archive_file" "origin_response" {
  type        = "zip"
  source_dir  = "${path.module}/lambda-origin-response/src"
  output_path = "${path.module}/lambda-origin-response.zip"
}

resource "aws_iam_role" "lambda_edge" {
  name               = "${local.hosted_zone_dash}-lambda-edge-role"
  assume_role_policy = "${data.aws_iam_policy_document.lambda_basic.json}"
}

data "aws_iam_policy_document" "lambda_basic" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"

      identifiers = [
        "lambda.amazonaws.com",
        "edgelambda.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_role_policy_attachment" "basic" {
  role       = "${aws_iam_role.lambda_edge.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

output "lambda_rewrite_arn" {
  value = "${aws_lambda_function.rewrite.arn}"
}

output "lambda_add_cors_arn" {
  value = "${aws_lambda_function.add_cors.arn}"
}

output "lambda_rewrite_qualified_arn" {
  value = "${aws_lambda_function.rewrite.qualified_arn}"
}

output "lambda_add_cors_qualified_arn" {
  value = "${aws_lambda_function.add_cors.qualified_arn}"
}

output "lambda_origin_response_qualified_arn" {
  value = "${aws_lambda_function.origin_response.qualified_arn}"
}
