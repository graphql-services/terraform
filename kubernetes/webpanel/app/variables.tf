variable "name" {}

variable "namespace" {}
variable "initialImage" {}

variable "apiURL" {}
variable "tokenURL" {}
variable "tokenScope" {
  default=""
}


variable "fileUploadURL" {
  default = "empty"
}
