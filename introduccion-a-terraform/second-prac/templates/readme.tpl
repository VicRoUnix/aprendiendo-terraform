# 🚀 ${project.name} - Día ${project.day}

**Estudiante:** ${project.student}  
**GitHub:** [@${project.github_user}](https://github.com/${project.github_user})  
**Progreso:** ${progress}% completado  
**Creado:** ${project.created_at}  

## 📊 Mi Progreso DevOps

### ✅ Herramientas Dominadas (${length(tools.mastered)})
%{ for tool in tools.mastered ~}
- [x] ${tool}
%{ endfor ~}

### 📚 Por Aprender (${length(tools.to_learn)})
%{ for tool in tools.to_learn ~}
- [ ] ${tool}
%{ endfor ~}

## 🎯 Objetivos del Día 22

- [x] Entender Infrastructure as Code
- [x] Instalar Terraform
- [x] Crear primer proyecto
- [x] Manejar variables y outputs
- [x] Usar templates y funciones

## 🏗️ Lo que he construido hoy

Este proyecto fue generado automáticamente usando **Terraform** y demuestra:

- 📝 Variables y tipos de datos
- 🧮 Locals y expresiones
- 📄 Templates con interpolación
- 📊 Outputs estructurados
- 🔢 Funciones built-in

## 🚀 Siguiente Paso

Mañana aprenderé sobre variables avanzadas, funciones y gestión de configuración en Terraform.

---
*Proyecto ID: `${project.id}`*  
*Generado automáticamente por Terraform 🤖*