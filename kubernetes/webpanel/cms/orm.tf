resource "kubernetes_service" "orm" {
  metadata {
    name      = "${var.name}-orm-${var.environment}"
    namespace = "${var.namespace}"
  }

  spec {
    selector {
      app = "${var.name}-orm-${var.environment}"
    }

    port {
      port        = 80
      target_port = 80
    }
  }
}

resource "kubernetes_deployment" "orm" {
  metadata {
    name      = "${var.name}-orm-${var.environment}"
    namespace = "${var.namespace}"
  }

  spec {
    selector {
      match_labels = {
        app = "${var.name}-orm-${var.environment}"
      }
    }

    template {
      metadata {
        labels {
          app = "${var.name}-orm-${var.environment}"
        }
      }

      spec {
        container {
          name              = "app"
          image             = "${var.ormImage}"
          image_pull_policy = "Always"

          port {
            container_port = 80
          }

          env {
            name = "DATABASE_URL"

            value_from {
              secret_key_ref {
                name = "${var.name}-${var.environment}"
                key  = "databaseURL"
              }
            }
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

        image_pull_secrets {
          name = "gitlab-registry"
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [
      "spec.0.template.0.spec.0.container.0.image",
    ]
  }
}
