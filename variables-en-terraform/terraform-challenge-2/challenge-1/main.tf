locals {
  # Generar configuración automática para cada ambiente
  environment_configs = {
    for env, config in var.environments :
    env => merge(config, {
      # Auto-sizing basado en environment
      storage_size = env == "prod" ? 100 : env == "staging" ? 50 : 20

      # Features automáticas
      cdn_enabled = env == "prod"
      waf_enabled = env == "prod"

      # Naming convention
      resource_prefix = "${var.app_name}-${env}"

      # Costos estimados
      monthly_cost = config.min_replicas * lookup(var.pricing_catalog, config.instance_type, 25.0)
    })
  }
}

resource "local_file" "multi_env_configs" {
  for_each = local.environment_configs

  filename = "solution/${var.app_name}-${each.key}.json"
  content = jsonencode({
    environment   = each.key
    instance_type = each.value.instance_type
    scaling = {
      min = each.value.min_replicas
      max = each.value.max_replicas
    }
    features = {
      monitoring = each.key == "prod" ? true : each.value.enable_monitoring
      ssl        = each.key == "prod" ? true : each.value.ssl_required
    }
    monthly_cost     = each.value.monthly_cost
    backup_retention =each.value.backup_retention
  })
}