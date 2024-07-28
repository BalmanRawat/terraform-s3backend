terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.54.1"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Project = var.project
      Stage = terraform.workspace
    }
  }
}

data "aws_caller_identity" "current" {}

module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"
  version = "4.1.2"

  bucket = "${terraform.workspace}-${var.project}-backend-bucket"
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  force_destroy = true

  versioning = {
    enabled = true
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }
}

# resource "aws_s3_bucket_server_side_encryption_configuration" "backend_bucket_encryption" {
#   bucket = aws_s3_bucket.backend_bucket.id
#   rule {
#     apply_server_side_encryption_by_default {
#       sse_algorithm = "AES256"
#     }
#   }
# }

resource "aws_dynamodb_table" "backend_table" {
  name           = "${terraform.workspace}-${var.project}-backend-table"
  hash_key       = "LockID"
  read_capacity = 1
  write_capacity = 1

  attribute {
    name = "LockID"
    type = "S"
  }

  # ttl {
  #   attribute_name = "LockID"
  #   enabled        = false
  # }

  tags = {
    "key" = "value"
  }
}