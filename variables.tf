variable "backend_bucket_name" {
  type = string
  description = "name of the backend bucket"
  default = "balman-backend-bucket"
}

variable "environment_name" {
  type = string
  description = "name of the environment"
  default = "balman-demo"
}

variable "environment_type" {
  type = string
  description = "environment type"
  default = "nonproduction"
}