provider "aws" {
  region = var.region
  profile = var.profile
  default_tags {
    tags = {
      Owner = var.owner
    }
  }
}

data "archive_file" "lambda_file" {
  for_each = var.list_lambda
  type        = "zip"
  source_file = "${path.module}/lambda_${each.key}/index.js"
  output_path = "${path.module}/lambda_${each.key}.zip"
}

resource "aws_lambda_function" "lambda" {
  for_each = var.list_lambda
  filename      = "${path.module}/lambda_${each.key}.zip"
  function_name = "${each.key}-${var.org_id}"
  role          = var.iam_role_lambda
  handler       = "index.handler"

  source_code_hash = data.archive_file.lambda_file[each.key].output_base64sha256
  publish       = true

  runtime = "nodejs22.x"
}

resource "aws_lambda_alias" "lambda_SimpleTaxCalculator_alias_dev" {
  name             = "dev"
  function_name    = aws_lambda_function.lambda["SimpleTaxCalculator"].arn
  function_version = "$LATEST"
}