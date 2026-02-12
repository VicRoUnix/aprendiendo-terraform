# infrastructure-calculator/main.tf
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

variable "instances" {
  type = map(object({
    count = number
    type  = string
    hours = number
  }))
  default = {
    "web" = {
      count = 2
      type  = "t3.micro"
      hours = 3
    }
    "bbd" = {
      count = 2
      type  = "t3.small"
      hours = 5
    }
    "proxy" = {
      count = 2
      type  = "t3.large"
      hours = 10
    }
  }
}

locals {
  # Precios por hora (ejemplo)
  pricing = {
    "t3.micro"  = 0.0104
    "t3.small"  = 0.0208
    "t3.medium" = 0.0416
    "t3.large"  = 0.0832
  }

  # Calcular costos
  costs = {
    for name, config in var.instances :
    name => config.count * config.hours * local.pricing[config.type]
  }

  total_cost = sum(values(local.costs))
}

resource "local_file" "cost_report" {
  filename = "cost-report.json"
  content = jsonencode({
    instances    = var.instances
    costs        = local.costs
    total_cost   = local.total_cost
    currency     = "USD"
    generated_at = timestamp()
  })
}

resource "local_file" "cost_report_2" {
  filename = "calculator-sol.txt"
  content = templatefile("${path.module}/templates/template-1.tpl", {
    instances    = var.instances
    costs        = local.costs
    total_cost   = local.total_cost
    currency     = "USD"
    generated_at = timestamp()
  })
}