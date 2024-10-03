# Lambda
- AWS Lambda is a serverless service that allows us to run applications without managing servers. It supports event-based triggers, for example, automatically triggering a function when an object is uploaded to S3.
### uses
- **no server management:** it automatically scales and manage the resources
- **Pay-per-use:** We only pay for the time the code is running.
**Example:** For example, as part of the identity and verification process, customers upload their IDs, To ensure the security of the uploaded files, we will scan them for malware using ClamAV, an open-source antivirus engine. An AWS Lambda function is triggered whenever a file is uploaded to the S3 bucket, which downloads the file, runs the ClamAV scan, and marks the file as safe or infected.
#### Note:
AWS Lambda has limited space (512 MB), so we can package the ClamAV binary and virus definition files and upload them to an S3 bucket. When the Lambda function is triggered, it downloads these files and scans the uploaded document.
  
## create a lambda function using terraform
```
### Lambda function
resource "aws_lambda_function" "scan_provided_file" {
  function_name = "${local.prefix_region}-scan-provided-file"
  description   = "Scans a file provided as base64 for malware and quarantines it if necessary"
  filename      = data.archive_file.lambda_placeholder_code.output_path
  role          = aws_iam_role.scan_provided_file_lambda_role.arn
  tags          = local.tags
  publish       = true
  runtime       = "nodejs20.x"
  handler       = "app.lambdaHandler"
  timeout       = 120
  memory_size   = 4096
 
  environment {
    variables = {
      BUCKET_MALWARE_DEFINITIONS = aws_s3_bucket.malware_definitions.id
      BUCKET_QUARANTINE          = aws_s3_bucket.quarantine.id
      NODE_OPTIONS               = "--enable-source-maps"
    }
  }
 
  ephemeral_storage {
    size = 1024
  }
 
  lifecycle {
    ignore_changes = [
      filename
    ]
  }
 
  vpc_config {
    subnet_ids         = data.aws_subnets.restricted.ids
    security_group_ids = [aws_security_group.scan_provided_file_lambda.id]
  }
 
  depends_on = [aws_cloudwatch_log_group.scan_provided_file_lambda, aws_iam_role_policy_attachment.scan_provided_file_lambda_role]
}
 
# Alias for the active version of the lambda - called by API Gateway
resource "aws_lambda_alias" "scan_provided_file" {
  name             = "live"
  function_name    = aws_lambda_function.scan_provided_file.function_name
  function_version = aws_lambda_function.scan_provided_file.version
 
  # alias will be updated as part of deployment pipeline. we don't want terraform to revert deployed changes
  lifecycle {
    ignore_changes = [
      function_version,
    ]
  }
}
 
# Provisioned Concurrency on the active version of the lambda
resource "aws_lambda_provisioned_concurrency_config" "scan_provided_file" {
  function_name                     = aws_lambda_alias.scan_provided_file.function_name
  provisioned_concurrent_executions = 3
  qualifier                         = aws_lambda_alias.scan_provided_file.name
}
 
## CloudWatch Log Group
resource "aws_cloudwatch_log_group" "scan_provided_file_lambda" {
  name              = "/aws/lambda/${local.prefix_region}-scan-provided-file"
  retention_in_days = 30
  lifecycle {
    prevent_destroy = false
  }
  tags = local.tags
}
```
