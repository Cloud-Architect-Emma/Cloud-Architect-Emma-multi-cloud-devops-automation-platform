# infra/stacks/gcp/dev/us-central1/storage/stack.tm.hcl


stack {
  name = "storage"
  tags = ["storage"]
}

generate_hcl "backend.tf" {
  content {
    body = templatefile("../../../../templates/tf-backend.tmpl", {
      backend_bucket = global.backend_bucket
      environment    = global.environment
      region         = global.region
      component      = "storage"
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
    body = templatefile("../../../../templates/module-storage.tmpl", {
      project_id  = global.project_id
      bucket_name = global.bucket_name
      location    = global.location
    })
  }
}
