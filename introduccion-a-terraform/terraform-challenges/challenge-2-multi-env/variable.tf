variable "environments" {
  type = map(object({
    region          = string
    instance_count  = number
    instance_type   = string
    database_size   = string
    backup_enabled  = bool
  }))
  default = {
    dev = {
      region         = "us-east-1"
      instance_count = 1
      instance_type  = "t3.micro"
      database_size  = "small"
      backup_enabled = false
    }
    staging = {
      region         = "us-west-2"
      instance_count = 2
      instance_type  = "t3.small"
      database_size  = "medium"
      backup_enabled = true
    }
    prod = {
      region         = "eu-west-1"
      instance_count = 3
      instance_type  = "t3.large"
      database_size  = "large"
      backup_enabled = true
    }
  }
}