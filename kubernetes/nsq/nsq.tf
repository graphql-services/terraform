resource "kubernetes_deployment" "nsqd" {
  metadata {
    name      = "${var.name}-nsqd"
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
          command = ["/nsqd", "--lookupd-tcp-address=${var.name}-nsqlookupd:4160", "--broadcast-address=${var.name}-nsqd"]

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

resource "kubernetes_service" "nsqd" {
  metadata {
    name      = "${var.name}-nsqd"
    namespace = "${var.namespace}"
  }

  spec {
    selector {
      name = "${var.name}"
    }

    port {
      port        = 4150
      target_port = 4150
      name        = "tcp"
    }

    port {
      port        = 4151
      target_port = 4151
      name        = "http"
    }
  }
}
