locals {
  # The table must have a primary key named LockID.
  # See below for more detail.
  # https://www.terraform.io/docs/backends/types/s3.html#dynamodb_table
  lock_key_id = "LockID"
}

provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "mai_backend" {
  bucket = var.bucket_name
  acl = var.acl
  tags = var.tags
  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.migue_key.arn
        sse_algorithm = "aws:kms"
      }
    }
  }
}

resource "aws_s3_bucket" "backend" {
  bucket = aws_s3_bucket.mai_backend.id
  policy = aws_s3_bucket.s3_policy.policy
}

resource "aws_kms_key" "state_lock_key" {
  description             = "KMS key terraform state lock"
  deletion_window_in_days = 10
  enable_key_rotation = true
}