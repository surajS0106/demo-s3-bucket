module "s3_bucket" {
  source = "./modules/s3_bucket"

  project     = var.project
  environment = var.environment

  bucket_name        = var.s3_bucket_name
  force_destroy      = var.s3_force_destroy
  versioning_enabled = var.s3_versioning_enabled

  cors_rules = var.s3_cors_rules
  tags       = var.tags
}
