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
data "aws_subnet_ids" "edb_private" {
  vpc_id = var.primary_vpc_id
  filter {
    name   = "tag:Name"
    values = ["*private*"]
  }
}

data "aws_security_groups" "edb_eks_security_groups" {
  filter {
    name   = "group-name"
    values = ["edbhub-*-cluster-sg"]
  }
  filter {
    name   = "vpc-id"
    values = ["${var.primary_vpc_id}"]
  }
}

resource "aws_lambda_function" "edb_lambda_function" {
  function_name = var.aws_lambda_name
  filename      = "${path.module}/../../files/lambdaSampleCode.zip"
  role          = var.role_arn
  handler       = "src/app.lambdaHandler"
  runtime       = var.lambda_runtime
  tags          = var.tags
  layers        = ["${var.lambda_vault_layer_arn}"]
  timeout       = var.lambda_timeout
  environment {
    variables = {
      VAULT_ADDR          = var.vault_addr,
      VAULT_AUTH_ROLE     = var.vault_auth_role,
      VAULT_AUTH_PROVIDER = "aws",
      VAULT_K8S_ENDPOINT  = var.vault_k8s_endpoint,
      VAULT_NAMESPACE     = var.vault_namespace,
      VAULT_SECRET_PATH   = var.vault_secret_path,
      VAULT_SKIP_VERIFY   = "true",
      VLE_VAULT_ADDR      = var.vault_addr,
      NODE_ENV            = var.node_env
    }
  }
  lifecycle {
    ignore_changes = [
      filename,
    ]
  }
  vpc_config {
    subnet_ids         = data.aws_subnet_ids.edb_private.ids
    security_group_ids = data.aws_security_groups.edb_eks_security_groups.ids
  }
}
```
