
# IAM role for lambda

data "aws_caller_identity" "current" {}

resource "aws_iam_role" "ecs_update_lambda_role" {
  name = "ecs_update_lambda_role"

  assume_role_policy = <<-EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
  EOF
}

resource "aws_iam_role_policy" "ecs_update_lambda_role_policy" {
  name = "ecs_update_lambda_role_policy"
  role = aws_iam_role.ecs_update_lambda_role.id
  policy = <<-EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "logs:CreateLogGroup",
            "Resource": "arn:aws:logs:${var.project_region}:${data.aws_caller_identity.current.account_id}:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:${var.project_region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/updateEcs:*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": "ecs:UpdateService",
            "Resource": "arn:aws:ecs:${var.project_region}:${data.aws_caller_identity.current.account_id}:service/cluster-discord-bot/discord-bot-app"
        },
        {
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ecsTaskExecutionRole"
        }
    ]
}
  EOF
}


# lambda

resource "aws_cloudwatch_log_group" "log_group_lambda" {
  name = "/aws/lambda/updateEcs"
}

data "archive_file" "update_ecs_lambda_zip" {
  type = "zip"
  output_path = "${path.module}/lambda.zip"

  source {
    content = templatefile("${path.module}/lambda.py",
    {
        securityGroup = var.ecs_sg_id
        privateSubnetIds = var.private_subnet_ids
    })
    filename = "lambda.py"
  }
}

resource "aws_lambda_function" "updateEcs" {
    filename            = "${path.module}/lambda.zip"
    source_code_hash    = data.archive_file.update_ecs_lambda_zip.output_base64sha256
    function_name       = "updateEcs"
    role                = aws_iam_role.ecs_update_lambda_role.arn
    handler             = "lambda.lambda_handler"
    runtime             = "python3.9"

    depends_on = [
        data.archive_file.update_ecs_lambda_zip
    ]  
}

# API Gateway
# https://advancedweb.hu/how-to-use-the-aws-apigatewayv2-api-to-add-an-http-api-to-a-lambda-function/

resource "aws_apigatewayv2_api" "bot_gw" {
  name          = "bot-update-http-endpoint"
  protocol_type = "HTTP"
  target        = aws_lambda_function.updateEcs.arn
}

resource "aws_lambda_permission" "apigw" {
	action        = "lambda:InvokeFunction"
	function_name = aws_lambda_function.updateEcs.arn
	principal     = "apigateway.amazonaws.com"

	source_arn = "${aws_apigatewayv2_api.bot_gw.execution_arn}/*/*"
}
