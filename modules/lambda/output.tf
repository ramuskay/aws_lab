output "lambda_object" {
  value = {
    for l in aws_lambda_function.lambda :
    l.function_name => ({
      name       = l.function_name
      invoke_arn = l.invoke_arn
      arn        = l.arn
    })
  }
}