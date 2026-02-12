===========================
Coste de instantcias 
===========================
%{ for name, data in instances ~}
===========================
Instancia: ${name}
    - Numero de nodos: ${data.count}
    - Tipo de instancia: ${data.type}
    - Horas trabajadas: ${data.hours}
    - Coste por minuto: ${costs[name]} ${currency}
    - Coste total: ${total_cost} ${currency}
    - Dia Facturado: ${generated_at}
===========================
%{ endfor ~}
===========================