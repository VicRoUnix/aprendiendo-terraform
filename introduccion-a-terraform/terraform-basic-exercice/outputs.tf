output "project_summary" {
  description = "Resumen del proyecto generado"
  value = {
    project_id       = random_id.project_id.hex
    student          = var.student_name
    files_generated  = length([for file, enabled in var.generate_files : file if enabled])
    tools_mastered   = length(var.tools_mastered)
    tools_to_learn   = length(var.tools_to_learn)
    progress_percent = local.progress_percent
    created_at       = local.timestamp
  }
}

output "generated_files" {
  description = "Lista de archivos generados"
  value = {
    readme_md        = var.generate_files.readme ? "README.md" : null
    project_config   = var.generate_files.config ? "outputs/project-config.json" : null
    progress_report  = var.generate_files.progress ? "outputs/progress-report.txt" : null
    learning_roadmap = var.generate_files.roadmap ? "outputs/learning-roadmap.md" : null
  }
}

output "learning_stats" {
  description = "Estadísticas de aprendizaje"
  value = {
    total_tools      = local.total_tools
    mastered_count   = length(var.tools_mastered)
    remaining_count  = length(var.tools_to_learn)
    progress_percent = local.progress_percent
    next_milestone   = local.progress_percent >= 50 ? "¡Más de la mitad!" : "Sigue adelante"
  }
}

output "quick_commands" {
  description = "Comandos útiles para explorar el proyecto"
  value = {
    view_readme     = "cat README.md"
    view_config     = "cat outputs/project-config.json | jq ."
    view_progress   = "cat outputs/progress-report.txt"
    view_roadmap    = "cat outputs/learning-roadmap.md"
    list_files      = "find . -name '*.tf' -o -name '*.json' -o -name '*.md' -o -name '*.txt'"
  }
}