terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
}

provider "docker" {}

# Build Docker image from app/Dockerfile
resource "docker_image" "app" {
  name = "ci-pipeline-app:latest"
  build {
    context    = "${path.module}/../app"
    dockerfile = "Dockerfile"
  }
}

resource "docker_container" "app" {
  name      = "ci-pipeline-container"
  image     = docker_image.app.image_id
  must_run  = true
  start     = true
  ports {
    internal = 8080
    external = 8080
  }
}
