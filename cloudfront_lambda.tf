# spa/lambda_at_edge

resource "aws_lambda_function" "rewrite" {
  function_name    = "${local.hosted_zone_dash}-rewrite"
  filename         = "${data.archive_file.rewrite.output_path}"
  source_code_hash = "${data.archive_file.rewrite.output_base64sha256}"
  role             = "${aws_iam_role.rewrite.arn}"
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

resource "aws_iam_role" "rewrite" {
  name               = "${local.hosted_zone_dash}-rewrite-role"
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
  role       = "${aws_iam_role.rewrite.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

output "lambda_rewrite_arn" {
  value = "${aws_lambda_function.rewrite.arn}"
}

output "lambda_rewrite_qualified_arn" {
  value = "${aws_lambda_function.rewrite.qualified_arn}"
}
