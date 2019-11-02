resource "kubernetes_service" "nsqlookupd" {
  metadata {
    name      = "${var.name}-nsqlookupd"
    namespace = "${var.namespace}"
  }

  spec {
    selector = {
      project = "${var.name}"
      app     = "nsqlookupd"
    }

    port {
      name        = "tcp"
      port        = 4160
      target_port = 4160
    }

    port {
      name        = "http"
      port        = 4161
      target_port = 4161
    }
  }
}

resource "kubernetes_deployment" "nsqlookupd" {
  metadata {
    name      = "${var.name}-nsqlookupd"
    namespace = "${var.namespace}"
  }

  spec {
    selector {
      match_labels {
        project = "${var.name}"
        app     = "nsqlookupd"
      }
    }

    template {
      metadata {
        labels = {
          project = "${var.name}"
          app     = "nsqlookupd"
        }
      }

      spec {
        container {
          name    = "nsqlookupd"
          image   = "nsqio/nsq"
          command = ["/nsqlookupd"]

          port {
            container_port = 4160
            name           = "tcp"
          }

          port {
            container_port = 4161
            name           = "http"
          }

          liveness_probe = [{
            http_get = [{
              path = "/ping"
              port = "http"
            }]

            initial_delay_seconds = "5"
            period_seconds        = "10"
          }]

          readiness_probe = [{
            http_get = [{
              path = "/ping"
              port = "http"
            }]

            initial_delay_seconds = "2"
            period_seconds        = "10"
          }]

          resources {
            requests {
              cpu    = "0.01"
              memory = "8Mi"
            }

            limits {
              cpu    = "1"
              memory = "256Mi"
            }
          }
        }
      }
    }
  }
}
