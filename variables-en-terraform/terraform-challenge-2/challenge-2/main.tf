# Challenge: Crear validaciones complejas
locals {
  configuration_validation = {
    # Validar que prod tenga configuración robusta
    prod_requirements_met = (
      var.environment == "prod" ? (
        var.application_config.features.monitoring == true &&
        var.application_config.features.backup == true &&
        var.application_config.runtime.memory >= 1024
      ) : true
    )
    
    # Validar coherencia entre variables 
    memory_ratio_valid = (
      (var.application_config.runtime.memory / var.application_config.runtime.cpu) >= 256 && 
      (var.application_config.runtime.memory / var.application_config.runtime.cpu) <= 2048
    )

    # Validar nombres únicos
    resource_names_unique = length(distinct([
      var.app_name,
      var.application_config.name
    ])) == 2
  }
  
  all_validations_passed = alltrue(values(local.configuration_validation))
}

# Generar reporte de validación
resource "local_file" "validation_report" {
  filename = "validation-report-${var.environment}.txt"
  content = <<-EOF
    VALIDATION REPORT
    =================
    
    Environment: ${var.environment}
    Timestamp: ${timestamp()}
    
    Validation Results:
    %{ for check, result in local.configuration_validation ~}
    ${result ? "✅" : "❌"} ${check}: ${result}
    %{ endfor ~}
    
    Overall Status: ${local.all_validations_passed ? "✅ PASSED" : "❌ FAILED"}
    
    %{ if !local.all_validations_passed ~}
    Please fix the failing validations before proceeding.
    %{ endif ~}
  EOF
}