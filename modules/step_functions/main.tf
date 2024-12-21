provider "aws" {
  region  = var.region
  profile = var.profile
  default_tags {
    tags = {
      Owner = var.owner
    }
  }
}

data "aws_iam_role" "states_execution_role" {
  name = "StatesExecutionRole-${var.region}"
}

resource "aws_sfn_state_machine" "sfn_state_machine" {
  name     = "ProductOrderPipeline-${var.org_id}"
  role_arn = data.aws_iam_role.states_execution_role.arn

  definition = <<EOF
{
    "Comment": "A more complicated tax calculator",
    "StartAt": "SimpleTaxCalculator",
    "States": {
        "SimpleTaxCalculator": {
            "Type": "Task",
            "Resource": "${var.lambda["SimpleTaxCalculator-o-y0itgn6otz"].arn}",
            "Next": "ChooseState"
        },
        "ChooseState": {
            "Type": "Choice",
            "Choices": [
                {
                    "Variable": "$.state",
                    "StringEquals": "CA",
                    "Next": "CaliforniaTaxCalculator"
                },
                {
                    "Variable": "$.state",
                    "StringEquals": "WI",
                    "Next": "WisconsinTaxCalculator"
                }
            ],
            "Default": "InvalidState"
        },
        "CaliforniaTaxCalculator": {
            "Type": "Task",
            "Resource": "${var.lambda["CaliforniaTaxCalculator-o-y0itgn6otz"].arn}",
            "End": true
        },
        "WisconsinTaxCalculator": {
            "Type": "Task",
            "Resource": "${var.lambda["WisconsinTaxCalculator-o-y0itgn6otz"].arn}",
            "End": true
        },
        "InvalidState": {
            "Type": "Fail",
            "Error": "Cannot calculate state tax!",
            "Cause": "Invalid State!"
        }
    }
}
EOF
}
