resource "kubernetes_deployment" "nsqlookupd" {
  metadata {
    name      = "${var.name}-nsqlookupd"
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
          command = ["/nsqlookupd"]

          port {
            container_port = 4171
          }

          resources {
            requests {
              cpu    = "0.01"
              memory = "16Mi"
            }

            limits {
              cpu    = "0.1"
              memory = "128Mi"
            }
          }
        }

        image_pull_secrets = "${var.image_pull_secrets}"
      }
    }
  }
}

resource "kubernetes_service" "nsqlookupd" {
  metadata {
    name      = "${var.name}-nsqlookupd"
    namespace = "${var.namespace}"
  }

  spec {
    selector {
      name = "${var.name}"
    }

    port {
      port        = 4160
      target_port = 4160
      name        = "tcp"
    }

    port {
      port        = 4161
      target_port = 4161
      name        = "http"
    }
  }
}
