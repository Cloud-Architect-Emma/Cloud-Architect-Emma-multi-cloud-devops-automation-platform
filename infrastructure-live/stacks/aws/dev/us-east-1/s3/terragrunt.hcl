include {
  path = find_in_parent_folders()
}

terraform {
  source = "github.com/terraform-aws-modules/terraform-aws-s3-bucket?ref=v3.0.0"
}

inputs = {
  bucket = "emma-devops-dev-bucket"
}


generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite"
  contents  = <<EOF
terraform {
  backend "s3" {}
}
EOF
}
