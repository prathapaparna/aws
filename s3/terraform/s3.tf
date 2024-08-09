resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name
  tags   = var.tags
}

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

resource "aws_s3_bucket_server_side_encryption_configuration" "sse_config" {
  bucket = aws_s3_bucket.s3_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.server_side_encryption.kms_key_name
      sse_algorithm     = var.server_side_encryption.sse_algorithm
    }
  }
}

resource "aws_s3_bucket_acl" "s3_acl" {
  count  = var.bucket_acl != null ? 1 : 0
  bucket = aws_s3_bucket.s3_bucket.id
  acl    = var.bucket_acl
}

resource "aws_s3_bucket_versioning" "s3_versioning" {
  bucket = aws_s3_bucket.s3_bucket.id
  versioning_configuration {
    status = var.bucket_versioning
  }
}

resource "aws_s3_bucket_policy" "s3_policy" {
  count  = var.bucket_policy != null ? 1 : 0
  bucket = aws_s3_bucket.s3_bucket.id
  policy = var.bucket_policy
}

resource "aws_s3_bucket_replication_configuration" "replication" {
  count      = var.replication_configuration != null ? 1 : 0
  bucket     = aws_s3_bucket.s3_bucket.id
  depends_on = [aws_s3_bucket_versioning.s3_versioning]
  role       = var.replication_configuration.role

  rule {
    status = var.replication_configuration.status
    filter {
      prefix = var.replication_configuration.filter_prefix
    }

    destination {
      bucket = var.replication_configuration.destination_bucket
      encryption_configuration {
        replica_kms_key_id = var.replication_configuration.encryption_key
      }
    }

    source_selection_criteria {
      sse_kms_encrypted_objects {
        status = var.replication_configuration.encrypted
      }
    }

    delete_marker_replication {
      status = var.replication_configuration.delete_marker
    }
  }
}

resource "aws_s3_bucket_website_configuration" "website_configuration" {
  bucket = aws_s3_bucket.s3_bucket.id
  count  = var.website_configuration != null ? 1 : 0
  redirect_all_requests_to {
    host_name = var.website_configuration.host_name
    protocol  = var.website_configuration.protocol
  }
}

resource "aws_s3_bucket_object_lock_configuration" "object_lock_configuration" {
  bucket              = aws_s3_bucket.s3_bucket.id
  count               = var.object_lock_configuration != null ? 1 : 0
  object_lock_enabled = var.object_lock_configuration.object_lock_enabled
  # rule {
  #   default_retention {
  #     mode = var.object_lock_configuration.rule.default_retention.mode
  #     days = var.object_lock_configuration.rule.default_retention.days
  #   }
  # }
}
