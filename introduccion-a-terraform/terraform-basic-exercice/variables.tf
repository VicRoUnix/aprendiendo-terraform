variable "student_name" {
  description = "Nombre del estudiante DevOps"
  type = string

  validation {
    condition = length(var.student_name) >= 2
    error_message = "El nombre debe tener al menos 2 caracteres."
  }
}

variable "github_user" {
  description = "Usuario de GitHub"
  type = string
  default = "devops-student"
}

variable "favorite_lenguage" {
  description = "Lenguaje de programacion favorito"
  type = string
  default = "Python"

  validation {
    condition = contains([
    "Python", "JavaScript", "Go", "Rust", "Java", "C#", "Ruby"
    ], var.favorite_language)
    error_message = "Debe ser un lenguaje soportado."
  }
}


variable "project_config" {
  description = "Configuración del proyecto"
  type = object({
    name        = string
    environment = string
    day         = number
  })
  
  validation {
    condition     = var.project_config.day >= 1 && var.project_config.day <= 90
    error_message = "El día debe estar entre 1 y 90."
  }
}

variable "tools_mastered" {
  description = "Herramientas DevOps ya dominadas"
  type        = list(string)
  default     = []
}

variable "tools_to_learn" {
  description = "Herramientas DevOps por aprender"
  type        = list(string)
  default     = []
}

variable "generate_files" {
  description = "Qué archivos generar"
  type = object({
    readme   = bool
    config   = bool
    progress = bool
    roadmap  = bool
  })
  default = {
    readme   = true
    config   = true
    progress = true
    roadmap  = true
  }
}