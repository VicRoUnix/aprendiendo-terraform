apiVersion: v1
kind: Service
metadata:
    name: ${service.name}
    labels:
        app: ${global_config.app_name}
        env: ${global_config.environment}
    spec:
        internal_url: ${service.internal_url}
        resources: 
            cpu: ${service.resources.cpu}
            memory: ${service.resources.memory}
        health_check:
            path: ${service.health_check.path}
            port: ${service.health_check.port}
        environment_variables:
            %{ for key, value in service.environment_vars ~}
                ${key}: "${value}"
            %{ endfor ~}
