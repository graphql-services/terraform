resource "kubernetes_service" "id-ui" {
  metadata {
    name      = "id-ui${var.namesuffix}"
    namespace = "${var.namespace}"
  }

  spec {
    selector {
      stack = "microid"
      app   = "id-ui${var.namesuffix}"
    }

    port {
      port        = 80
      target_port = 80
    }
  }
}

resource "kubernetes_deployment" "id-ui" {
  metadata {
    name      = "id-ui${var.namesuffix}"
    namespace = "${var.namespace}"
  }

  spec {
    selector {
      match_labels = {
        stack = "microid"
        app   = "id-ui${var.namesuffix}"
      }
    }

    template {
      metadata {
        labels {
          stack = "microid"
          app   = "id-ui${var.namesuffix}"
        }
      }

      spec {
        container {
          name              = "app"
          image             = "graphql/id-ui"
          image_pull_policy = "Always"

          port {
            container_port = 80
          }

          env {
            name  = "REACT_APP_API_URL"
            value = "https://${var.hostname}/graphql"
          }

          env {
            name  = "REACT_APP_TOKEN_URL"
            value = "https://${var.hostname}/oauth/token"
          }

          env {
            name  = "REACT_APP_FILE_UPLOAD_URL"
            value = "https://${var.hostname}/files/upload"
          }

          env {
            name  = "REACT_APP_SCOPE"
            value = "id"
          }

          env {
            name  = "REACT_APP_CLIENT_ID"
            value = "default"
          }

          env {
            name  = "REACT_APP_CLIENT_SECRET"
            value = "default"
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
