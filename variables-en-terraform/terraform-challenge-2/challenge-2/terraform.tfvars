# terraform.tfvars

environment = "prod"
app_name    = "nginx"

application_config = {
  name = "backend-app"
  
  features = {
    monitoring = true
    backup     = true
  }
  
  runtime = {
    memory = 1024
    cpu    = 2
  }
}