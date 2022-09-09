terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      EnvironmentName = var.environment_name
      EnvironmentType = var.environment_type
    }
  }
}

resource "aws_s3_bucket" "backend_bucket" {
  bucket = var.backend_bucket_name
}

resource "aws_s3_bucket_acl" "bucket-acl" {
  bucket = aws_s3_bucket.backend_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "backend-bucket-versioning" {
  bucket = aws_s3_bucket.backend_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "backend-bucket-encryption" {
  bucket = aws_s3_bucket.backend_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_policy" "backend_bucket_policy" {
  bucket = aws_s3_bucket.backend_bucket.id
  policy = data.aws_iam_policy_document.backend_bucket_policy.json
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "backend_bucket_policy" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.current.account_id]
    }
    effect = "Allow"
    actions = ["s3:ListBucket"]
    resources = [
      aws_s3_bucket.backend_bucket.arn
    ]
  }

  statement {
    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.current.account_id]
    }
    effect = "Allow"
    actions = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
    resources = [
      "${aws_s3_bucket.backend_bucket.arn}/*"
    ]
  }
}

resource "aws_dynamodb_table" "backend_table" {
  name           = "backend-table"
  hash_key       = "LockID"
  read_capacity = 1
  write_capacity = 1

  attribute {
    name = "LockID"
    type = "S"
  }
}