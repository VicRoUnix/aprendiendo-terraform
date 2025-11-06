variable "student_name" {
  description = "Nombre del estudiante"
  type = string
  default = "VicRoUnix student"

  validation {
    condition = length(var.student_name) > 2
    error_message = "El nombre debe tener al menos 3 caracteres."
  }
}

variable "devops_tools" {
  description = "Herramietnas DevOps que estamos aprendiendo"
  type        = list(string)
  default = [
    "Docker",
    "Docker Compose", 
    "Terraform",
    "GitHub Actions",
    "Kubernetes"
  ]
}

variable "create_backup" {
  description = "Crear archivo de respaldo"
  type        = bool
  default     = true
}
