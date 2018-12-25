resource "kubernetes_deployment" "nsqadmin" {
  metadata {
    name      = "${var.name}-nsqadmin"
    namespace = "${var.namespace}"
  }

  spec {
    selector {
      name = "${var.name}"
    }

    template {
      metadata {
        labels {
          name = "${var.name}"
        }
      }

      spec {
        container {
          name    = "app"
          image   = "nsqio/nsq"
          command = ["/nsqadmin", "--lookupd-http-address=${var.name}-nsqlookupd:4161"]

          port {
            container_port = 4171
          }

          resources {
            requests {
              cpu    = "0.01"
              memory = "8Mi"
            }

            limits {
              cpu    = "0.1"
              memory = "32Mi"
            }
          }
        }

        image_pull_secrets = "${var.image_pull_secrets}"
      }
    }
  }
}

resource "kubernetes_service" "nsqadmin" {
  metadata {
    name      = "${var.name}-nsqadmin"
    namespace = "${var.namespace}"
  }

  spec {
    selector {
      name = "${var.name}"
    }

    port {
      port        = 80
      target_port = 4171
    }
  }
}
