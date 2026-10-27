output "s3_bucket_id" {
  description = "S3 bucket ID (name)."
  value       = module.s3_bucket.id
}

output "s3_bucket_arn" {
  description = "S3 bucket ARN."
  value       = module.s3_bucket.arn
}

output "s3_bucket_regional_domain_name" {
  description = "Regional domain name of the bucket."
  value       = module.s3_bucket.bucket_regional_domain_name
}
