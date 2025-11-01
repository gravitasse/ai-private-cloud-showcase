terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

resource "local_file" "example" {
  filename = "example.txt"
  content  = "This demonstrates local Terraform provider use."
}
