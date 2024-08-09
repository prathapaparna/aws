buckets
lifecycle configuration
serverside encryption
acl (access-control-list)
versioning
bucket policy
replication configuration
object lock
static website hosting

# life_cycle_configuration
- Manages lifecycle of objects stored in an  S3 bucket.
- These rules help to reduce storage costs by automatically transitioning objects to different storage classes or deleting them after a certain period.
  
  **Actions:**
  
**Transition:** Move objects to another storage class after a certain number of days.

For example, you can move objects to the S3 Standard-IA (Infrequent Access) storage class after 30 days, and then to S3 Glacier after 365 days.

**Expiration:** Permanently delete objects after a certain period.

**Abort Incomplete Multipart Uploads:** Automatically delete incomplete multipart uploads after a specific time.
```
resource "aws_s3_bucket_lifecycle_configuration" "s3_bucket_lifecycle_rule" {
  count  = length(var.lifecycle_rules) > 0 ? 1 : 0
  bucket = aws_s3_bucket.s3_bucket.bucket

  dynamic "rule" {
    for_each = var.lifecycle_rules

    content {
      id     = rule.value.id
      status = rule.value.status

      dynamic "expiration" {
        for_each = rule.value.expiration_config

        content {
          days                         = expiration.value.days
          expired_object_delete_marker = expiration.value.expired_object_delete_marker
        }
      }

      dynamic "noncurrent_version_expiration" {
        for_each = rule.value.noncurrent_version_expiration_config

        content {
          noncurrent_days = noncurrent_version_expiration.value.days
        }
      }

      dynamic "transition" {
        for_each = rule.value.transitions_config

        content {
          days          = transition.value.days
          storage_class = transition.value.storage_class
        }
      }

      dynamic "noncurrent_version_transition" {
        for_each = rule.value.noncurrent_version_transitions_config

        content {
          noncurrent_days = noncurrent_version_transition.value.days
          storage_class   = noncurrent_version_transition.value.storage_class
        }
      }
    }
  }
}
```
# server_side_encryption

- Server-Side Encryption (SSE) in Amazon S3 refers to the process of encrypting data at rest, meaning that data stored in S3 is automatically encrypted by AWS before being saved to disk and automatically decrypted when accessed by authorized users. 
This ensures that even if the data is accessed without permission, it cannot be read or understood.
- we can encrypt the key by kms keys or aws managed keys
```
resource "aws_s3_bucket_server_side_encryption_configuration" "sse_config" {
  bucket = aws_s3_bucket.s3_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.server_side_encryption.kms_key_name
      sse_algorithm     = var.server_side_encryption.sse_algorithm
    }
  }
}
```
# acl & Bucket policy
-An Access Control List (ACL) in Amazon S3 is a method to manage access to the objects and buckets stored in S3. ACLs allow you to define who can access specific resources and what operations they can perform on those resources.

**How ACLs Work in S3**
Each S3 bucket and object has an associated ACL, which defines which AWS accounts or groups (like "everyone" or "authenticated users") have access and what type of access they have. ACLs are essentially a set of grants that provide permissions to specific entities.
**Note**
- instead of acl and bucket policy we can use IAM roles and IAM policies
- **example iam policy**
```
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::my-bucket",
                "arn:aws:s3:::my-bucket/*"
            ]
        }
    ]
}
```
# Versioning

Versioning in Amazon S3 is a feature that allows you to keep multiple versions of an object in the same S3 bucket. This means that every time you upload a new version of an object with the same key (name), S3 keeps the previous version(s) instead of overwriting the object. Versioning provides a way to recover from unintended overwrites or deletions.

# replication_configuration






  





