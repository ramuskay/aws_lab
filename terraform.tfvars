region             = "us-east-1"
owner              = "adeschamps"
profile            = { "admin" : "961341552159_AdminAccessKlanik", "lambda" : "961341552159_LambdaLab", "api_gateway" : "961341552159_APIGatewayLab", "step_function" : "961341552159_StepFunctionLab" }
availability_zones = { us-east-1 : ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1e", "us-east-1f"] }
az_of_the_ec2      = "b"
userdb             = "JLOPEZ"
groupdbadmin       = "IAM.GRP.AWSFOR.DEV.KFC.DBADMIN"
list_lambda        = ["CaliforniaTaxCalculator", "SimpleTaxCalculator", "WisconsinTaxCalculator"]