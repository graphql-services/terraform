resource "kubernetes_service" "oauth" {
  metadata {
    name      = "oauth${var.namesuffix}"
    namespace = "${var.namespace}"
  }

  spec {
    selector {
      stack = "microid"
      app   = "oauth${var.namesuffix}"
    }

    port {
      port        = 80
      target_port = 80
    }
  }
}

resource "kubernetes_deployment" "oauth" {
  metadata {
    name      = "oauth${var.namesuffix}"
    namespace = "${var.namespace}"
  }

  spec {
    selector {
      match_labels = {
        stack = "microid"
        app   = "oauth${var.namesuffix}"
      }
    }

    template {
      metadata {
        labels {
          stack = "microid"
          app   = "oauth${var.namesuffix}"
        }
      }

      spec {
        container {
          name              = "app"
          image             = "graphql/oauth"
          image_pull_policy = "Always"

          port {
            container_port = 80
          }

          env {
            name = "DATABASE_URL"

            value_from {
              secret_key_ref {
                name = "microid${var.namesuffix}"
                key  = "oauthDatabaseURL"
              }
            }
          }

          env {
            name  = "IDP_URL"
            value = "http://idp${var.namesuffix}/graphql"
          }

          env {
            name  = "JWKS_PROVIDER_URL"
            value = "http://jwks-provider${var.namesuffix}/private/jwks.json"
          }

          env {
            name  = "ID_URL"
            value = "http://id${var.namesuffix}/graphql"
          }

          env {
            name  = "SCOPE_VALIDATOR_URL"
            value = "oauth-scope-validator${var.namesuffix}:80"
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
