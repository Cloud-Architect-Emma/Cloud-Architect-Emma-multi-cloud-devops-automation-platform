stack {
  name = "artifact-registry"
  tags = ["artifact-registry"]
}

generate_hcl "backend.tf" {
  content {
    body = templatefile("../../../../templates/tf-backend.tmpl", {
      backend_bucket = global.backend_bucket
      environment    = global.environment
      region         = global.region
      component      = "artifact-registry"
    })
  }
}

generate_hcl "provider.tf" {
  content {
    body = templatefile("../../../../templates/provider-gcp.tmpl", {
      project_id = global.project_id
      region     = global.region
    })
  }
}

generate_hcl "main.tf" {
  content {
    body = templatefile("../../../../templates/module-artifact-registry.tmpl", {
      project_id = global.project_id
      repo_name  = global.repo_name
      location   = global.location
    })
  }
}
