# EL mundo de Terraform
Infraestructura como codigo con Terraform.

---

# Instalacion en entorno UBUNTU/DEBIAN
```bash
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update && sudo apt install terraform

terraform version
```
## Post-Instalacion
### Autocompletado de comandos
```bash
#Bash
terraform -install-autocomplete
```

---

# Anatomia de un Proyecto Terraform
## Estructura Basica
```plaintext
mi-proyecto-terraform/
├── main.tf              # 🏠 Configuración principal y recursos
├── variables.tf         # 📝 Definición de variables de entrada
├── outputs.tf           # 📤 Definición de valores de salida
├── locals.tf            # 🧮 Variables locales (calculadas)
├── versions.tf          # 📌 Versiones de Terraform y providers
├── terraform.tfvars     # 🔧 Valores de variables (NO SUBIR A GIT)
├── terraform.tfvars.example # 📋 Ejemplo de variables (seguro para GIT)
├── .terraform.lock.hcl  # 🔒 Lock file de dependencias (SUBIR A GIT)
├── .gitignore           # 🚫 Archivos ignorados por Git
├── README.md            # 📚 Esta documentación
├── .terraform/          # 📦 Plugins y módulos (ignorado)
├── *.tfstate* # 💾 Archivos de estado (ignorado)
└── modules/             # 🏗️ Módulos reutilizables
    ├── networking/      #   (Módulo de red)
    ├── compute/         #   (Módulo de cómputo)
    └── storage/         #   (Módulo de almacenamiento)
```

## Estructura Avanzada
```paintext
terraform-infrastructure/
├── environments/           # 🌍 Configuraciones por ambiente
│   ├── dev/
│   │   ├── main.tf
│   │   ├── terraform.tfvars
│   │   └── backend.tf
│   ├── staging/
│   └── prod/
├── modules/                # 📦 Módulos personalizados
│   ├── vpc/
│   ├── ec2/
│   ├── rds/
│   └── iam/
├── shared/                 # 🤝 Recursos compartidos
│   ├── data-sources.tf
│   ├── providers.tf
│   └── remote-state.tf
├── scripts/                # 🔧 Scripts de automatización
│   ├── deploy.sh
│   ├── destroy.sh
│   └── validate.sh
├── docs/                   # 📚 Documentación
├── tests/                  # 🧪 Tests de infraestructura
└── .github/workflows/      # 🚀 CI/CD pipelines
```

---

# Explicacion de los Archivos
## main.tf - El corazon del Proyecto
```tf
# Configuracion del provider
terraform {
    required_version = ">=version1.6"
    requied_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

# Configuracion del provider AWS
provider "aws" {
    region = var.aws_region
    default_tags{
        tag = {
            Environment = var.enviroment
            Project = var.project_name
            ManagedBy = "Terraform"
        }
    }
}

# Recursos principales
resource "aws_vpc" "main" {
    cidr_block           = var.vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support   = true

    tags = {
        Name = "${var.project_name}-vpc"
    }
}
```
### Main.tf
- terraform { ... } : Declara requisitos de Terraform y providers (no crea recursos). Aquí se indica qué versión mínima de Terraform usar y qué proveedor (AWS) se necesita.
- provider "aws" { ... } : Configura cómo Terraform se conecta a AWS (región, tags por defecto). Las credenciales se toman del entorno o del perfil configurado.
- default_tags : Etiquetas que se aplican automáticamente a los recursos creados por este proveedor (p. ej. Environment, Project).
- resource "aws_vpc" "main" : Crea la VPC (red virtual) principal. `cidr_block` define el rango de IPs; las opciones de DNS habilitan resolución dentro de la VPC; `tags` añade un nombre identificable.
- Variables usadas (deben definirse en `variables.tf` o `terraform.tfvars`): `var.aws_region`, `var.enviroment` (o `var.environment`), `var.project_name`, `var.vpc_cidr`.

## variables.tf - Parametrizacion
```tf
variable "aws_region" {
    description = "Region de AWS donde crear los recursos"
    type = string
    default = "us-east-1"

    validation{
        condition = contains(["us-east-1", "us-west-2", "eu-west-1"], var.aws_region)
        error_message = "La region debe ser una de las soportadas."
    }
}

variable "environment" {
    description = "Ambiente de despliegue"
    type = string

    validation {
        condition = contains(["dev", "staging", "prod"], var.environment)
        error_message = "El ambiente debe ser dev, staging o prod."
    }
}

variable "vpc_cidr" {
    description = "CIDR block para la VPC"
    type = string
    default = "10.0.0.0/16"

    validation {
        condition = can(cidrhost(var.vpc_cidr, 0))
        error_message = "VPC CIDR debe ser un bloqque CIDR valido."
    }
    
}

variable "instance_types" {
        description = "Tipos de instancia permitidos"
        type        = list(string)
        default     = ["t3.micro", "t3.small"]
}

variable "tags" {
    description = "Tags adicionales"
    type        = map(string)
    default     = {}
}
```

### Mini explicación (variables.tf)

- `variable "aws_region"` : Define la región de AWS donde se crearán los recursos. Tiene un `default` (ej. `us-east-1`) y una `validation` que asegura que sólo se elijan regiones soportadas.
- `variable "environment"` : Nombre del entorno (por ejemplo `dev`, `staging` o `prod`). Se valida que esté entre los valores permitidos para evitar errores al aplicar la infraestructura.

- `variable "vpc_cidr"` : Rango CIDR para la VPC (ej. `10.0.0.0/16`). Hay una validación que intenta comprobar que la cadena es un bloque CIDR válido.

- `variable "instance_types"` : Lista con los tipos de instancia permitidos (p. ej. `t3.micro`). Se usa para limitar las opciones cuando crees instancias.

- `variable "tags"` : Mapa de etiquetas adicionales que se pueden añadir a recursos. Útil para metadata y facturación.

Notas rápidas:
- Las `validation` ayudan a atrapar errores antes de ejecutar `terraform apply`.
- Las variables se definen aquí (metadatos, validaciones y defaults), y sus valores reales pueden proporcionarse en `terraform.tfvars` o por `-var` en la línea de comandos.

Errores/tipos detectados en el ejemplo (recomendado corregir antes de usar):
- En la validación de `environment` se usa `vars.environment` pero debe ser `var.environment`.
- Mensajes y texto contienen pequeñas faltas: por ejemplo `bloqque` → `bloque`.


## outputs.tf - Resultados Utiles
```tf
output "vpc_id" {
    description = "ID de la VPC creada"
    value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
    description = "CIDR block de la VPC"
    value       = aws_vpc.main.cidr_block
}

output "environment_info" {
  description = "Información del ambiente"
  value = {
    environment = var.environment
    region      = var.aws_region
    vpc_id      = aws_vpc.main.id
  }
}

# Output sensible (no se muestra en logs)
output "database_password" {
  description = "Password de la base de datos"
  value       = random_password.db_password.result
  sensitive   = true
}
```

### Mini explicación (outputs.tf)

- `output "vpc_id"` : Devuelve el ID de la VPC creada (`aws_vpc.main.id`). Es útil cuando quieres pasar ese valor a otros módulos o herramientas.
- `output "vpc_cidr_block"` : Muestra el CIDR asignado a la VPC (ej. `10.0.0.0/16`). Sirve para comprobaciones o para usar en scripts externos.
- `output "environment_info"` : Agrupa varios datos en un mapa (entorno, región y vpc_id). Es práctico para obtener en una sola llamada información relevante del despliegue.
- `output "database_password"` : Ejemplo de salida sensible (`sensitive = true`). No se muestra en la salida por defecto de `terraform apply` ni con `terraform output` sin la flag `-json`, pero **sí** queda en el archivo de estado (sé cuidadoso con el `terraform.tfstate`).

Notas rápidas:
- Los `output` son la forma de exponer valores creados por Terraform para usarlos fuera (scripts, otros módulos o para mostrar información útil una vez aplicado).
- Para ver los outputs después de aplicar: `terraform output` o `terraform output -json` (útil para integraciones). Si el output es `sensitive`, su valor no se muestra directamente.
- Ten en cuenta que los valores aparecen en el state; no almacenes secretos en outputs sin considerar cifrado del state o backend seguro.

## locals.tf - Variables Calculadas
```tf
locals {
  # Nombre común para recursos
  name_prefix = "${var.project_name}-${var.environment}"
  
  # Tags comunes
  common_tags = merge(var.tags, {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
    CreatedAt   = formatdate("YYYY-MM-DD", timestamp())
  })
  
  # Configuración por ambiente
  environment_config = {
    dev = {
      instance_count = 1
      instance_type  = "t3.micro"
    }
    staging = {
      instance_count = 2
      instance_type  = "t3.small"
    }
    prod = {
      instance_count = 3
      instance_type  = "t3.medium"
    }
  }
  
  # Configuración actual
  current_config = local.environment_config[var.environment]
}
```
###  Mini explicación (locals.tf)

- `local.name_prefix`: Combina el nombre del proyecto y el ambiente (ej. `mi-proyecto-dev`). Es útil para generar nombres de recursos consistentes.
- `local.common_tags`: Define las etiquetas (tags) que se aplicarán a todos los recursos. Usa `merge` para fusionar tags personalizadas (`var.tags`) con tags estándar (Environment, Project, ManagedBy), asegurando un etiquetado coherente.
- `local.environment_config` y `local.current_config`: El primero actúa como una "tabla" (mapa) que define parámetros para cada entorno (tipo de instancia, número). El segundo selecciona dinámicamente la configuración correcta de esa tabla (ej. `local.environment_config["prod"]`) basándose en la `var.environment` actual.

Notas rápidas:
- Los `locals` son "variables de ayuda" internas. No son entradas (inputs) ni salidas (outputs).
- Su propósito principal es el principio **DRY (Don't Repeat Yourself)**: defines un valor complejo una sola vez y lo reutilizas en múltiples lugares.
- Hacen el `main.tf` mucho más limpio y fácil de mantener. En lugar de escribir una lógica de tags compleja en cada recurso, solo escribes `tags = local.common_tags`.
- Se accede a ellos siempre usando el prefijo `local.` (ej. `local.name_prefix`).

## versions.tf - Control de versiones
```tf
terraform {
  required_version = ">= 1.6"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.4"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
  
  # Backend para estado remoto
  backend "s3" {
    bucket         = "mi-terraform-state-bucket"
    key            = "infrastructure/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}
```
### 📌 Mini explicación (versions.tf)

- `required_version = ">= 1.6"`: Fuerza a que se use Terraform 1.6 o superior. Evita que el código falle si alguien usa una versión antigua.
- `required_providers`: Lista los "plugins" (proveedores) que `terraform init` debe descargar para interactuar con las APIs (en este caso, AWS, Random y TLS).
- `aws = { version = "~> 5.0" }`: Fija la versión del proveedor de AWS. El `~>` (operador pesimista) permite actualizaciones menores (ej. `5.1`), pero bloquea saltos mayores (como `6.0`), previniendo errores por cambios drásticos en el proveedor.
- `backend "s3"`: Configura el **estado remoto**. Le dice a Terraform que guarde el archivo `terraform.tfstate` (el mapa de tu infraestructura) en un bucket de S3, en lugar de guardarlo localmente en tu PC.
- `dynamodb_table = "terraform-state-lock"`: Configura el **bloqueo de estado (State Locking)**. Usa una tabla de DynamoDB para "bloquear" el estado mientras alguien ejecuta un `apply`. Esto es crucial para equipos, ya que evita que dos personas modifiquen la infraestructura al mismo tiempo.

Notas rápidas:
- Este archivo es lo primero que se lee al ejecutar `terraform init`.
- `terraform init` usa este archivo para descargar los proveedores y conectarse al backend de S3.
- El backend remoto (S3 + DynamoDB) es la práctica estándar número uno para trabajar en equipo de forma segura.
- El archivo `.terraform.lock.hcl` (que SÍ debe subirse a Git) se genera basándose en estas restricciones de versión.

---

# Comandos Basicos de terraform
## Inicializacion
```bash
# Inicializar el directorio dee trabajo
terraform init

# Reinicializar forzando descarga de providers
terraform init -upgrade

# Inicializar con backend especifico
terraform init -backend-config="bucket=my-tf-state"
```
## Validacion
```bash
# Validar sintaxis de configuración
terraform validate

# Formatear código automáticamente
terraform fmt

# Formatear recursivamente
terraform fmt -recursive

# Solo verificar formato (sin cambiar)
terraform fmt -check
```
## Planificacion
```bash
# Ver qué cambios se aplicarán
terraform plan

# Guardar plan en archivo
terraform plan -out=tfplan

# Plan con variables específicas
terraform plan -var="student_name=Roxs"

# Plan con archivo de variables
terraform plan -var-file="prod.tfvars"

# Plan mostrando solo cambios
terraform plan -compact-warnings
```
## Aplicacion
```bash
# Aplicar cambios (pide confirmación)
terraform apply

# Aplicar sin confirmación
terraform apply -auto-approve

# Aplicar plan guardado
terraform apply tfplan

# Aplicar con variables
terraform apply -var="student_name=TuNombre"
```
## Inspeccion
```bash
# Ver estado actual
terraform show

# Listar recursos en estado
terraform state list

# Ver detalles de un recurso
terraform state show local_file.devops_journey

# Ver outputs
terraform output

# Ver output específico
terraform output generated_files
```
## Destruccion
```bash
# Destruir todos los recursos
terraform destroy

# Destruir sin confirmación
terraform destroy -auto-approve

# Destruir recursos específicos
terraform destroy -target=local_file.terraform_config
```

---

# Conceptos clave explicados
## PROVIDERS
Los providers son plugins que permiten a Terraform interactuar con APIs:
```tf
# Provider para AWS
provider "aws" {
  region = "us-east-1"
}

# Provider para Docker
provider "docker" {
  host = "unix:///var/run/docker.sock"
}

# Provider para Kubernetes
provider "kubernetes" {
  config_path = "~/.kube/config"
}

# Provider para múltiples clouds
provider "azurerm" {
  features {}
}
```
## RESOURCES
Los resources son los componentes de infraestructura:
```tf
# Sintaxis general
resource "tipo_provider_recurso" "nombre_local" {
  argumento1 = "valor1"
  argumento2 = "valor2"
  
  # Bloque anidado
  configuracion {
    opcion = "valor"
  }
  
  # Meta-argumentos
  depends_on = [otro_recurso.ejemplo]
  count      = 3
  
  # Lifecycle
  lifecycle {
    prevent_destroy = true
  }
}
```
## STATE MANAGEMENT
Terraform mantiene un estado que:
```plaintext
# ¿Qué contiene el estado?
✅ Mapeo entre configuración y recursos reales
✅ Metadatos de recursos
✅ Dependencias entre recursos
✅ Configuración de providers

# ¿Por qué es importante?
✅ Detecta cambios (drift detection)
✅ Optimiza operaciones (parallelization)
✅ Permite rollbacks seguros
✅ Habilita colaboración en equipo
```
### Comandos de Estado
```bash
# Backup manual del estado
cp terraform.tfstate terraform.tfstate.backup

# Importar recurso existente
terraform import aws_instance.example i-1234567890abcdef0

# Remover recurso del estado (sin destruir)
terraform state rm aws_instance.example

# Mover recurso en el estado
terraform state mv aws_instance.old aws_instance.new

# Actualizar estado con infraestructura real
terraform refresh
```
## Variables y Tipos
```tf
# Tipos básicos
variable "string_example" {
  type    = string
  default = "hello"
}

variable "number_example" {
  type    = number
  default = 42
}

variable "bool_example" {
  type    = bool
  default = true
}

# Tipos complejos
variable "list_example" {
  type    = list(string)
  default = ["item1", "item2", "item3"]
}

variable "map_example" {
  type = map(string)
  default = {
    key1 = "value1"
    key2 = "value2"
  }
}

variable "object_example" {
  type = object({
    name    = string
    age     = number
    active  = bool
  })
  default = {
    name   = "example"
    age    = 30
    active = true
  }
}
```