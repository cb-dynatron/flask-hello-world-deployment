remote_state {
  backend = "s3"
  config = {
    bucket         = "flask-hello-world-terraform-state"
    key            = format("%s/terraform.tfstate", path_relative_to_include())
    region         = get_env("AWS_REGION")
    encrypt        = true
    dynamodb_table = "flask-hello-world-lock-table"
  }

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

inputs = {
  aws_region = get_env("AWS_REGION")
}
