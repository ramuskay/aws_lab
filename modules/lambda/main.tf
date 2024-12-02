provider "aws" {
  region = var.region
  profile = var.profile
  default_tags {
    tags = {
      Owner = var.owner
    }
  }
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/index.js"
  output_path = "${path.module}/lambda_SimpleTaxCalculator.zip"
}

resource "aws_lambda_function" "lambda_SimpleTaxCalculator" {
  filename      = "${path.module}/lambda_SimpleTaxCalculator.zip"
  function_name = "SimpleTaxCalculator-${var.org_id}"
  role          = var.iam_role_lambda
  handler       = "index.handler"

  source_code_hash = data.archive_file.lambda.output_base64sha256
  publish       = true

  runtime = "nodejs22.x"
}

# Not sure about this one
# resource "aws_lambda_alias" "lambda_SimpleTaxCalculator_alias_prd" {
#   name             = "prod"
#   function_name    = aws_lambda_function.lambda_SimpleTaxCalculator.arn
#   function_version = "1"
# }

resource "aws_lambda_alias" "lambda_SimpleTaxCalculator_alias_dev" {
  name             = "dev"
  function_name    = aws_lambda_function.lambda_SimpleTaxCalculator.arn
  function_version = "$LATEST"
}