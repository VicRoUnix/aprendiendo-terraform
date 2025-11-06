output "generated_files" {
  description = "Archivos generados por Terraform"
  value = {
    main_file   = local_file.devops_journey.filename
    config_file = local_file.terraform_config.filename
  }
}

output "file_content_preview" {
  description = "Vista previa del contenido"
  value       = substr(local_file.devops_journey.content, 0, 100)
}

output "project_summary" {
  description = "Resumen del proyecto"
  value = {
    student           = var.student_name
    files_created     = 2
    terraform_version = "1.6+"
    timestamp        = local.timestamp
  }
}