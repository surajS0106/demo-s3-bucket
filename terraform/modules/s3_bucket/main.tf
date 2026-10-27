resource "random_id" "suffix" {
  # 3 bytes => 6 hex chars
  byte_length = 3
}

locals {
  generated_bucket_name = lower(replace("${var.project}-${var.environment}-${random_id.suffix.hex}", "_", "-"))
  final_bucket_name     = coalesce(var.bucket_name, local.generated_bucket_name)
}

resource "aws_s3_bucket" "this" {
  bucket        = local.final_bucket_name
  force_destroy = var.force_destroy

  tags = merge(
    var.tags,
    {
      Name        = local.final_bucket_name
      Project     = var.project
      Environment = var.environment
    }
  )
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Suspended"
  }
}

resource "aws_s3_bucket_cors_configuration" "this" {
  count  = length(var.cors_rules) > 0 ? 1 : 0
  bucket = aws_s3_bucket.this.id

  dynamic "cors_rule" {
    for_each = var.cors_rules

    content {
      allowed_headers = try(cors_rule.value.allowed_headers, [])
      allowed_methods = [for m in cors_rule.value.allowed_methods : upper(m)]
      allowed_origins = cors_rule.value.allowed_origins
      expose_headers  = try(cors_rule.value.expose_headers, [])
      max_age_seconds = try(cors_rule.value.max_age_seconds, null)
    }
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
