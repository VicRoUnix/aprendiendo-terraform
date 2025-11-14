# ${project.name}   - Dia ${project.day}
**Estudiante:** ${project.student}
**Github:** [@${project.github_user}](https://github.com/${project.github_user})
**Progreso:** ${progress}% completado
**Creado:** ${project.created_at}

## Mi progreso DevOps

### Herramientas dominadas (${length(tools.mastered)})
%{ for tool in tools.mastered ~}
- [x] ${tool}
%{ endfor ~}

## Por Aprender (${length(tools.to_learn)})
%{ for tool in tools.to_learn ~}
- [x] ${tool}
%{ endfor ~}

## Objetivos del Dia 22
- [x] Entender Infrastructure as Code
- [x] Instalar Terraform
- [x] Crear primer proyecto
- [x] Manejar variables y outputs
- [x] Usar templates y funciones

## Lo que he construido hoy

Este proyecto fue generado automaticamente usando **Terraform** y demuestra:

- Variables y tipos de datos
- Locals y expresiones
- Templates con interpolación
- Outputs estructurados
- Funciones built-in

## Siguiente Paso

Mañana aprenderé sobre variables avanzadas, funciones y gestión de configuración en Terraform.

---
*Proyecto ID: `${project.id}`*  
*Generado automáticamente por Terraform 🤖*