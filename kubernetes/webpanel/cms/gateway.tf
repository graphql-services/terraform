resource "kubernetes_service" "gateway" {
  metadata {
    name      = "${var.name}-gateway-${var.environment}"
    namespace = "${var.namespace}"
  }

  spec {
    selector = {
      app = "${var.name}-gateway-${var.environment}"
    }

    port {
      port        = 80
      target_port = 80
    }
  }
}

resource "kubernetes_deployment" "gateway" {
  metadata {
    name      = "${var.name}-gateway-${var.environment}"
    namespace = "${var.namespace}"
  }

  spec {
    selector {
      match_labels = {
        app = "${var.name}-gateway-${var.environment}"
      }
    }

    replicas = "1"

    template {
      metadata {
        labels = {
          app = "${var.name}-gateway-${var.environment}"
        }
      }

      spec {
        container {
          name  = "gateway"
          image = "graphql/gateway:feature-nautilus-gateway"

          port {
            container_port = 80
          }

          env {
            name  = "GRAPHQL_URL_0"
            value = "http://${var.name}-orm-${var.environment}/graphql"
          }

          liveness_probe {
            http_get {
              path = "/healthcheck"
              port = 80
            }

            initial_delay_seconds = "10"
            timeout_seconds       = "10"
            period_seconds        = "10"
          }

          readiness_probe {
            http_get {
              path = "/healthcheck"
              port = 80
            }

            initial_delay_seconds = "10"
            timeout_seconds       = "10"
            period_seconds        = "10"
          }

          resources {
            requests {
              cpu    = "0.01"
              memory = "8Mi"
            }

            limits {
              cpu    = "0.05"
              memory = "64Mi"
            }
          }
        }
      }
    }
  }
}
