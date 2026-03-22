provider "" {
  token = "" # or `GITHUB_TOKEN`
}

resource "github_repository" "example" {
    name                = "repository-useng-terraform-22032026"
    description         = "automated repository creation using terraform"
    visibility          = "public"
}