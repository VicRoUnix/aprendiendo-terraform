variable "microservices" {
  type = map(object({
    port         = number
    language     = string
    memory_mb    = number
    replicas     = number
    dependencies = list(string)
  }))
}

variable "app_name" {
  description = "Nombre de la aplicacion"
  type = string

  validation {
    condition = can(regex("^[a-z][a-z0-9-]*[a-z0-9]$", var.app_name))
    error_message = "Introduce el formato correcto de nombre"
  }
}

variable "environment" {
  description = "Tipos de estado del proyecto"
  type = string

  validation {
    condition = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment debe ser: dev, staging o prod"
  }
}
