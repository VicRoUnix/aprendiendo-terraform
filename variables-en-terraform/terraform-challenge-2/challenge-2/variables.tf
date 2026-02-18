variable "environment" {
  description = "Entorno de despliegue (dev/staging/prod)"
  type = string
  default = "prod"

  validation {
    condition = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment debe ser: dev,staging, o prod."
  }
}

variable "app_name" {
  description = "Nombre de la aplicacion"
  type = string
  default = "nginx"

  validation {
    condition = can(regex("^[a-z][a-z0-9-]*[a-z0-9]$", var.app_name))
    error_message = "El nombre de la aplicacion tiene que cumplir con el estandard"
  }
}

variable "application_config" {
  description = "Configuracion completa de la aplicacion"
  type = object({
    name = string

    features = object({
      monitoring = bool
      backup = bool
    })

    runtime = object({
      memory = number
      cpu = number
    })
  })

    validation {
        condition = can(regex("^[a-z][a-z0-9-]*[a-z0-9]$", var.application_config.name))
        error_message = "name debe seguir convenciones de naming"
    }

    validation {
        condition = var.application_config.runtime.cpu > 0 
        error_message = "No puede haber un valor negativo en la cpu" 
    }

    validation {
        condition = var.application_config.runtime.memory >= 0
        error_message = "No puede haber un valor negativo de memoria"
    }

    validation {
        condition = (var.application_config.runtime.memory / var.application_config.runtime.cpu) >= 256 && (var.application_config.runtime.memory / var.application_config.runtime.cpu) <= 2048
        error_message = "El valor del ratio tiene que ser major de 256 y menor de 2048"
    }
}
