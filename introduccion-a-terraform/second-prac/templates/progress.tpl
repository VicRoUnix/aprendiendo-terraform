===========================================
📊 REPORTE DE PROGRESO - DÍA ${day}
===========================================

👨‍💻 Estudiante: ${student}
📅 Fecha: ${timestamp}
🎯 Progreso General: ${progress}%

📈 ESTADÍSTICAS:
- Herramientas dominadas: ${length(mastered)}
- Por aprender: ${length(to_learn)}
- Total en roadmap: ${length(mastered) + length(to_learn)}

✅ HERRAMIENTAS DOMINADAS:
%{ for tool in mastered ~}
  ✓ ${tool}
%{ endfor ~}

📚 PRÓXIMAS HERRAMIENTAS:
%{ for tool in to_learn ~}
  ◯ ${tool}
%{ endfor ~}

💪 ¡Sigue así! Cada día te acercas más a ser un 
   DevOps Engineer completo.

===========================================
Generado por Terraform - Infrastructure as Code