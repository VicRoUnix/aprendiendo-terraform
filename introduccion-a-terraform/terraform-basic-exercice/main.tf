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

# Generar ID unico para el proyecto
resource "random_id" "project_id" {
  byte_length = 8
}

# Timestamp de creacion
resource "time_static" "creation_time" {}

# Variables locales calculadas
locals {
  project_id = random_id.project_id.hex
  timestamp  = formatdate("YYYY-MM-DD hh:mm:ss", time_static.creation_time.rfc3339)

  # Datos del proyecto
  project_data = {
    id          = local.project_id
    name        = var.project_config.name
    student     = var.student_name
    day         = var.project_config.day
    environment = var.project_config.environment
    created_at  = local.timestamp
    github_user = var.github_user
    lenguage    = var.favorite_lenguage
  }

  # Progreso calculado
  total_tools      = length(var.tools_mastered) + length(var.tools_to_learn)
  mastered_tools   = length(var.tools_mastered)
  progress_percent = floor((local.mastered_tools / local.total_tools))
}

# Archivo README personalizado
resource "local_file" "readme" {
  count    = var.generate_files.readme ? 1 : 0
  filename = "README.md"
  content = templatefile("${path.module}/templates/readme.tpl", {
    project = local.project_data
    tools = {
      mastered = var.tools_mastered
      to_learn = var.tools_to_learn
    }
    progress = local.progress_percent
  })
}

# Configuracion del proyecto en JSON
resource "local_file" "project_config" {
  count    = var.generate_files.config ? 1 : 0
  filename = "outputs/project-config.json"
  content = jsonencode({
    project = local.project_data
    terraform = {
      version = "1.6+"
      providers = {
        local  = "~> 2.4"
        random = "~> 3.4"
      }
    }
    learning = {
      tools_mastered   = var.tools_mastered
      tools_to_learn   = var.tools_to_learn
      total_tools      = local.total_tools
      progress_percent = local.progress_percent
    }
    files_generated = [
      for file_type, enabled in var.generate_files : file_type if enabled
    ]
  })
}

# Reporte de progreso
resource "local_file" "progress_report" {
  count    = var.generate_files.progress ? 1 : 0
  filename = "outputs/progress-report.txt"
  content = templatefile("${path.module}/templates/progress.tpl", {
    student   = var.student_name
    day       = var.project_config.day
    progress  = local.progress_percent
    mastered  = var.tools_mastered
    to_learn  = var.tools_to_learn
    timestamp = local.timestamp
  })
}

# Roadmap personalizado
resource "local_file" "learning_roadmap" {
  count    = var.generate_files.roadmap ? 1 : 0
  filename = "outputs/learning-roadmap.md"
  content = templatefile("${path.module}/templates/roadmap.tpl", {
    student  = var.student_name
    github   = var.github_user
    lenguage = var.favorite_lenguage
    mastered = var.tools_mastered
    to_learn = var.tools_to_learn
    day      = var.project_config.day
  })
}