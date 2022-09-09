terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  # A backend block cannot refer to named values (like input variables, locals, or data source attributes). https://www.terraform.io/language/settings/backends/configuration
  backend "s3" {
    bucket = "balman-backend-bucket"
    key = "examples/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "backend-table"
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_sqs_queue" "consumer_queue" {
  name = "example-queue-change-1"
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq.arn
    maxReceiveCount     = 2
  })

  tags = {
    Name = "example-queue"
  }
}

resource "aws_sqs_queue" "dlq" {
  name = "example-dlq"

  tags = {
    Name = "example-dlq"
  }
}
