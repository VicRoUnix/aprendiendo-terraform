terraform {
  required_version = ">= 1.6"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.4"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.9"
    }
  }
}

variable "workload_type" {
  description = "Tipo de carga de trabajo"
  type        = string
  validation {
    condition = contains([
      "web", "api", "database", "cache", "queue"
    ], var.workload_type)
    error_message = "Workload type must be valid."
  }
}

locals {
  # Configuración dinámica según workload
  workload_configs = {
    web = {
      instances    = 3
      type         = "t3.medium"
      load_balancer = true
      auto_scaling  = true
    }
    api = {
      instances    = 2
      type         = "t3.small"
      load_balancer = true
      auto_scaling  = true
    }
    database = {
      instances    = 1
      type         = "r5.large"
      load_balancer = false
      auto_scaling  = false
    }
    cache = {
      instances    = 2
      type         = "r5.medium"
      load_balancer = false
      auto_scaling  = true
    }
    queue = {
      instances    = 1
      type         = "t3.small"
      load_balancer = false
      auto_scaling = true
    }
  }
  
  selected_config = local.workload_configs[var.workload_type]
}

resource "local_file" "infrastructure_plan" {
  filename = "infrastructure-plan-${var.workload_type}.json"
  content = jsonencode({
    workload_type = var.workload_type
    configuration = local.selected_config
    estimated_cost = local.selected_config.instances * (
      local.selected_config.type == "t3.micro"  ? 8.5 :
      local.selected_config.type == "t3.small"  ? 17 :
      local.selected_config.type == "t3.medium" ? 34 :
      local.selected_config.type == "r5.medium" ? 67 :
      local.selected_config.type == "r5.large"  ? 134 : 50
    )
    components = {
      compute      = "EC2 Instances"
      networking   = "VPC + Subnets"
      load_balancer = local.selected_config.load_balancer ? "Application Load Balancer" : null
      auto_scaling = local.selected_config.auto_scaling ? "Auto Scaling Group" : null
    }
  })
}