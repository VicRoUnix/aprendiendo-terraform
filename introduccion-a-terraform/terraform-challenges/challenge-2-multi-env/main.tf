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

# Generar archivo por ambiente
resource "local_file" "environment_configs" {
  for_each = var.environments
  
  filename = "environments/${each.key}.txt"
  content = templatefile("${path.module}/templates/template-2.tpl", {
    env_name = each.key
    config   = each.value
  })
}
