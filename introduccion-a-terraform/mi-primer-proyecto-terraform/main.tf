# 1.Configuracion del proyecto
terraform {
  required_version = ">=1.6"
  required_providers {
    local = {
        source = "hashicorp/local"
        version = "> 2.4"
    }
    random = {
        source = "hashicorp/random"
        version = "~> 3.4"
    }
  }
}

# 2.Generar contenido dinamico
resource "random_id" "file_suffix" {
  byte_length = 4
}

# 3. Variables locales
locals {
  timestamp = formatdate("YYYY-MM-DD hh:mm:ss", timestamp())
  filename = "terraform-${random_id.file_suffix.hex}.txt"
}

# 4. Recurso principal
resource "local_file" "devops_journey" {
  filename = local.filename
  content = templatefile("${path.module}/templates/welcome.tpl",{
    name = var.student_name
    day = 22
    timestamp = local.timestamp
    tools = var.devops_tools
  })

  # Permisos del archivo
  file_permission = "0644"
}

# 5. Recurso adicional
resource "local_file" "terraform_config" {
  filename = "terraform-config.json"
  content = jsonencode({
    project = {
        name        ="devops-with-vic"
        day         = 22
        topic       = "terraform-basics"
        created_at  = var.student_name
    }
    terraform = {
        version = "1.6+"
        providers = {
            local = "~> 2.4"
            random = "~> 3.4"
        }
    }
    learning_objectives = [
        "Understand IaC concepts",
        "Learn Terraform basics",
        "Create first resources",
        "Manage state files"
    ]
  })
}