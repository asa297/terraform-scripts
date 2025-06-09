# modules/gcp-project/main.tf

resource "google_project" "new_project" {
  name            = var.project_name
  project_id      = var.project_id
  billing_account = var.billing_account

  # delete this project when the resource is destroyed (when you run `terraform destroy`)
  # deletion_policy = "DELETE"
}
