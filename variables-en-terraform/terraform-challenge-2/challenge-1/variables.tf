variable "app_name" {
  description = "Nombre de la aplicacion"
  type        = string
  default     = "app"

  validation {
    condition     = can(regex("^[a-z][a-z0-9]*[a-z0-9]$", var.app_name))
    error_message = "app_name debe seguir convenciones de naming."
  }
}


variable "environments" {
  type = map(object({
    instance_type     = string
    min_replicas      = number
    max_replicas      = number
    enable_monitoring = bool
    backup_retention  = number
    ssl_required      = bool
  }))

  default = {
    "web" = {
      instance_type     = "t3.micro"
      min_replicas      = 1
      max_replicas      = 5
      enable_monitoring = true
      backup_retention  = 2
      ssl_required      = true
    }

    "bbd" = {
      instance_type     = "t3.small"
      min_replicas      = 2
      max_replicas      = 3
      enable_monitoring = true
      backup_retention  = 2
      ssl_required      = true
    }

    "monitoring" = {
      instance_type     = "t3.medium"
      min_replicas      = 1
      max_replicas      = 1
      enable_monitoring = true
      backup_retention  = 2
      ssl_required      = false
    }
  }

  validation {
    condition = alltrue([
      for env, config in var.environments :
      config.min_replicas <= config.max_replicas
    ])
    error_message = "El min replicas tiene que ser menor o igual que max replicas para todos los entornos"
  }
}

variable "pricing_catalog" {
  description = "Catalago de precios por tipo de instancia"
  type        = map(number)
  default = {
    "t3.micro"  = 8.5
    "t3.small"  = 17.0
    "t3.medium" = 34.0
  }

  validation {
    condition = alltrue([
      for prices in values(var.pricing_catalog) : prices >= 0
    ])
    error_message = "No puede tener valores negativos"
  }
}