provider "aws" {
  region = var.region
  profile = var.profile
  default_tags {
    tags = {
      Owner = var.owner
    }
  }
}

resource "null_resource" "detach_policy" {
  lifecycle {
    #create_before_destroy = true # Useful in case when you want to open port 80 instead of 8080 (no downtime)
    prevent_destroy = false  # Allow resource to be destroyed
  }  
  triggers = {
    profile      = var.profile
    dbadmin       = aws_iam_group.dbadmin.name
    policy    = aws_iam_policy.policy.arn
  }  
  provisioner "local-exec" {
    when = destroy
    command = "aws iam detach-group-policy --profile ${self.triggers.profile} --group ${self.triggers.dbadmin} --policy-arn ${self.triggers.policy}"
    on_failure = continue
  }
}

resource "aws_iam_policy" "policy" {
  name        = "${var.owner}.IAM.POLICY.AWSFOR.DEV.KFC.DBKFC"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": "rds:*",
        "Resource": "arn:aws:rds:::"
      }
    ]
  })

  tags = {
    Name = "${var.owner}-policy"
  }  
}

resource "aws_iam_group" "dbadmin" {
  name = "${var.groupdbadmin}"
}

resource "aws_iam_group_policy_attachments_exclusive" "a" {
  group_name  = aws_iam_group.dbadmin.name
  policy_arns = [aws_iam_policy.policy.arn]
}

resource "aws_iam_user" "userdb" {
  name = "${var.userdb}"
}

resource "aws_iam_user_group_membership" "m" {
  user = aws_iam_user.userdb.name

  groups = [
    aws_iam_group.dbadmin.name,
  ]
}