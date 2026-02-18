environment = "prod"
app_name = "appelstore"

microservices = {
  "backend-api" = {
    port = 8080
    language = "java"
    memory_mb = 1024
    replicas = 3
    dependencies = []
  }

  "frontend-web" = {
    port = 3000
    language = "nodejs"
    memory_mb = 512
    replicas = 2
    dependencies = ["backend-api"]
  }
}