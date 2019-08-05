resource "kubernetes_service" "oauth-scope-validator" {
  metadata {
    name      = "oauth-scope-validator${var.namesuffix}"
    namespace = "${var.namespace}"
  }

  spec {
    selector {
      stack = "microid"
      app   = "oauth-scope-validator${var.namesuffix}"
    }

    port {
      port        = 80
      target_port = 80
    }
  }
}

resource "kubernetes_deployment" "oauth-scope-validator" {
  metadata {
    name      = "oauth-scope-validator${var.namesuffix}"
    namespace = "${var.namespace}"
  }

  spec {
    selector {
      match_labels = {
        stack = "microid"
        app   = "oauth-scope-validator${var.namesuffix}"
      }
    }

    template {
      metadata {
        labels {
          stack = "microid"
          app   = "oauth-scope-validator${var.namesuffix}"
        }
      }

      spec {
        container {
          name              = "app"
          image             = "graphql/oauth-scope-validator"
          image_pull_policy = "Always"

          port {
            container_port = 80
          }

          env {
            name  = "PORT"
            value = "80"
          }

          resources {
            requests {
              cpu    = "0.01"
              memory = "8Mi"
            }

            limits {
              cpu    = "0.02"
              memory = "32Mi"
            }
          }

          liveness_probe {
            tcp_socket {
              port = 80
            }

            initial_delay_seconds = "10"
            timeout_seconds       = "5"
            period_seconds        = "10"
          }

          readiness_probe {
            tcp_socket {
              port = 80
            }

            initial_delay_seconds = "10"
            timeout_seconds       = "5"
            period_seconds        = "10"
          }
        }
      }
    }
  }
}
