# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform from "preprod-balman-backend-table"
resource "aws_dynamodb_table" "table" {
  billing_mode                = "PROVISIONED"
  deletion_protection_enabled = false
  hash_key                    = "LockID"
  name                        = "preprod-balman-backend-table"
  range_key                   = null
  read_capacity               = 1
  restore_date_time           = null
  restore_source_name         = null
  restore_to_latest_time      = null
  stream_enabled              = false
  stream_view_type            = null
  table_class                 = "STANDARD"
  tags = {
    Project = "balman"
    Stage   = "preprod"
    key     = "value"
  }
  tags_all = {
    Project = "balman"
    Stage   = "preprod"
    key     = "value"
  }
  write_capacity = 1
  attribute {
    name = "LockID"
    type = "S"
  }
  point_in_time_recovery {
    enabled = false
  }
  ttl {
    attribute_name = "LockID"
    enabled        = true
  }
}
