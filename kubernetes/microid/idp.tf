resource "kubernetes_service" "idp" {
  metadata {
    name      = "idp${var.namesuffix}"
    namespace = "${var.namespace}"
  }

  spec {
    selector = {
      stack = "microid"
      app   = "idp${var.namesuffix}"
    }

    port {
      port        = 80
      target_port = 80
    }
  }
}

resource "kubernetes_deployment" "idp" {
  metadata {
    name      = "idp${var.namesuffix}"
    namespace = "${var.namespace}"
  }

  spec {
    selector {
      match_labels = {
        stack = "microid"
        app   = "idp${var.namesuffix}"
      }
    }

    template {
      metadata {
        labels = {
          stack = "microid"
          app   = "idp${var.namesuffix}"
        }
      }

      spec {
        container {
          name              = "app"
          image             = "graphql/idp"
          image_pull_policy = "Always"

          port {
            container_port = 80
          }

          env {
            name = "DATABASE_URL"

            value_from {
              secret_key_ref {
                name = "microid${var.namesuffix}"
                key  = "idpDatabaseURL"
              }
            }
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
              cpu    = "0.1"
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

  depends_on = ["kubernetes_secret.main"]
}
