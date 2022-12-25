# IAM permission requirements

This is not optimized.

## Policy: X_ApiGatewayV2_FullAccess

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "X_ApiGatewayV2_FullAccess",
            "Effect": "Allow",
            "Action": "apigateway:*",
            "Resource": "*"
        }
    ]
}
```

## User Group

* X_ApiGatewayV2_FullAccess
* AmazonEC2FullAccess
* IAMFullAccess
* CloudWatchFullAccess
* AmazonECS_FullAccess
* AmazonVPCFullAccess
* AWSLambda_FullAccess
* AmazonS3FullAccess (only if S3 backend is used)
* AWSCloudShellFullAccess (only if executed from CloudShell)
