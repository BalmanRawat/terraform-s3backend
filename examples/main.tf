terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  # A backend block cannot refer to named values (like input variables, locals, or data source attributes). https://www.terraform.io/language/settings/backends/configuration
  backend "s3" {
    bucket = "preprod-balman-backend-bucket"
    key    = "s3backend-examples/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "preprod-balman-backend-table"
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  region = "us-west-1"
  alias = "west"
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

# resource "aws_sqs_queue" "dlq_west" {
#   provider = aws.west
#   name = "example-dlq"

#   tags = {
#     Name = "example-dlq"
#   }
# }
