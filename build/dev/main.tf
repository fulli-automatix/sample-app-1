module "web-app" {
  source       = "../../modules/webapp"
  vpc_id       = var.vpc_id
  default_tags = var.default_tags
}