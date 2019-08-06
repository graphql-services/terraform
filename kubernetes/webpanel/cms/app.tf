module "app" {
  source = "../app"

  name         = "${var.name}-app-${var.environment}"
  namespace    = "${var.namespace}"
  initialImage = "${var.appImage}"

  apiURL   = "https://${var.hostname}/graphql"
  tokenURL = "${var.tokenURL}"
}
