resource "kubernetes_ingress" "ingress" {
  metadata {
    name      = "auth${var.namesuffix}"
    namespace = "${var.namespace}"

    annotations {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/$1"
      "nginx.ingress.kubernetes.io/use-regex"      = "true"
      "certmanager.k8s.io/cluster-issuer"          = "letsencrypt"

      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
      "nginx.ingress.kubernetes.io/enable-cors"  = "true"

      # "nginx.ingress.kubernetes.io/cors-allow-methods"     = "PUT, GET, POST, OPTIONS"
      # "nginx.ingress.kubernetes.io/cors-allow-origin"      = "*"
      # "nginx.ingress.kubernetes.io/cors-allow-credentials" = "true"
    }
  }

  spec {
    rule {
      host = "${var.hostname}"

      http {
        path {
          path = "/(graphql)"

          backend {
            service_name = "id${var.namesuffix}"
            service_port = 80
          }
        }

        path {
          path = "/(.*)"

          backend {
            service_name = "id-ui${var.namesuffix}"
            service_port = 80
          }
        }

        path {
          path = "/oauth/(.*)"

          backend {
            service_name = "oauth${var.namesuffix}"
            service_port = 80
          }
        }

        path {
          path = "/idp/(.*)"

          backend {
            service_name = "idp${var.namesuffix}"
            service_port = 80
          }
        }

        path {
          path = "/.well-known/jwks.json"

          backend {
            service_name = "jwks-provider${var.namesuffix}"
            service_port = 80
          }
        }
      }
    }

    tls {
      hosts       = ["${var.hostname}"]
      secret_name = "microid-certificate${var.namesuffix}"
    }
  }
}
