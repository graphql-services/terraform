variable "project" {}
variable "name" {}

variable "namespace" {
  default = "projects"
}

variable "image" {}

variable "env" {
  type    = "list"
  default = []
}

variable "hostname" {
  default = ""
}

variable "path" {
  default = "/"
}

variable "service_ports" {
  type = "list"

  default = [{
    port        = 80
    target_port = 80
  }]
}

variable "command" {
  type    = "list"
  default = []
}

variable "liveness_probe" {
  type    = "list"
  default = []
}

variable "readiness_probe" {
  type    = "list"
  default = []
}
