resource "kubernetes_service" "jwks-provider" {
  metadata {
    name      = "jwks-provider"
    namespace = "${var.namespace}"
  }

  spec {
    selector {
      stack = "microid"
      app   = "jwks-provider${var.namesuffix}"
    }

    port {
      port        = 80
      target_port = 80
    }
  }
}

resource "kubernetes_deployment" "jwks-provider" {
  metadata {
    name      = "jwks-provider${var.namesuffix}"
    namespace = "${var.namespace}"
  }

  spec {
    selector {
      match_labels = {
        stack = "microid"
        app   = "jwks-provider${var.namesuffix}"
      }
    }

    template {
      metadata {
        labels {
          stack = "microid"
          app   = "jwks-provider${var.namesuffix}"
        }
      }

      spec {
        container {
          name              = "app"
          image             = "graphql/jwks-provider"
          image_pull_policy = "Always"

          port {
            container_port = 80
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
            http_get {
              path = "/healthcheck"
              port = 80
            }

            initial_delay_seconds = "10"
            timeout_seconds       = "5"
            period_seconds        = "10"
          }

          readiness_probe {
            http_get {
              path = "/healthcheck"
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
