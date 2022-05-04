terraform {
  backend "s3" {
    bucket = "shared-tf-states-912969828712"
    key    = "dev-sample-app-1"
    region = "eu-west-1"
  }
}