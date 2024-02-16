terraform {
  source = "../../modules/flask-hello-world"
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  vpc_id = "vpc-0cbd5c9fafbdba20b"

  certificate_arn = "arn:aws:acm:us-east-2:339713176830:certificate/e3c60c85-064c-4a34-bfb5-e0d0db7d6cf9"
}
