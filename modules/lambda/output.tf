output "lambda_invoke_arn" {
  value = aws_lambda_function.lambda_SimpleTaxCalculator.invoke_arn
}

output "lambda_name" {
  value = aws_lambda_function.lambda_SimpleTaxCalculator.function_name
}
