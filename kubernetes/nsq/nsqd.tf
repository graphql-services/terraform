resource "kubernetes_service" "nsqd" {
  metadata {
    name      = "${var.name}-nsqd"
    namespace = "${var.namespace}"
  }

  spec {
    selector {
      project = "${var.name}"
      app     = "nsqd"
    }

    port {
      name        = "tcp"
      port        = 4150
      target_port = 4150
    }

    port {
      name        = "http"
      port        = 4151
      target_port = 4151
    }
  }
}

resource "kubernetes_deployment" "nsqd" {
  metadata {
    name      = "${var.name}-nsqd"
    namespace = "${var.namespace}"
  }

  spec {
    selector {
      project = "${var.name}"
      app     = "nsqd"
    }

    template {
      metadata {
        labels {
          project = "${var.name}"
          app     = "nsqd"
        }
      }

      spec {
        container {
          name    = "nsqlookupd"
          image   = "nsqio/nsq"
          command = ["/nsqd", "--lookupd-tcp-address=${var.name}-nsqlookupd:4160", "--broadcast-address=${var.name}-nsqd"]

          port {
            container_port = 4150
            name           = "tcp"
          }

          port {
            container_port = 4151
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
