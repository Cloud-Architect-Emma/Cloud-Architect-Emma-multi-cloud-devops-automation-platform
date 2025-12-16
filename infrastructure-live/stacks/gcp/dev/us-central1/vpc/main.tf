module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 9.0"

  project_id   = "terraform-multi-cloud-480415"
  network_name = "vpc-dev"

  subnets = [
    {
      subnet_name           = "subnet-dev"
      subnet_ip             = "10.20.1.0/24"
      subnet_region         = "us-central1"
      subnet_private_access = true

      secondary_ip_ranges = [
        {
          range_name    = "pods"
          ip_cidr_range = "10.21.0.0/16"
        },
        {
          range_name    = "services"
          ip_cidr_range = "10.22.0.0/20"
        }
      ]
    }
  ]
}

output "vpc_name" {
  description = "The name of the VPC network"
  value       = module.vpc.network_name
}

output "subnet_name" {
  description = "The name of the subnet"
  value       = module.vpc.subnets["us-central1/subnet-dev"].name
}
