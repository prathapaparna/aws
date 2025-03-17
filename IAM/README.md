# IAM
## Authentication is about who you are.
## Authorization is about what you can do.

## IAM user vs IAM role
- An **IAM user** represents a single person or application with permanent credentials like a username, password, or access keys and long-term access to AWS services.
    -  If a developer in your team needs access to manage AWS resources via the AWS CLI, you can create an IAM user for them and assign policies to control what they can access.
- An **IAM rol**e is an AWS identity without permanent credentials .
    -  For example, to allow a Lambda function to access S3, we can create an IAM role, provide it with an S3 access policy, and attach this role to the Lambda function. This enables the Lambda function to fetch objects from S3.
- An **IAM group** allows us to attach multiple users to a single group and manage group-level access permissions


![image](https://github.com/user-attachments/assets/3e7bd033-8bc3-423d-83b6-1a78ecf6998a)
