terraform {
  source = "../../modules/aws-ecr"
}

inputs = {
  repository_name = "dev-ecr"
  lifecycle_policy = <<POLICY
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Keep last 10 images tagged 'latest' and remove older images",
      "selection": {
        "tagStatus": "tagged",
        "tagPrefixList": ["latest"],
        "countType": "imageCountMoreThan",
        "countNumber": 10
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
POLICY
}
