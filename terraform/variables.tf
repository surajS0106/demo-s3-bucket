variable "aws_region" {
  description = "AWS region to deploy into."
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS CLI named profile to use. Leave null to use default credential chain (env vars, role, etc.)."
  type        = string
  default     = null
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)."
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, staging, prod."
  }
}

variable "project" {
  description = "Project/application identifier used for naming and tags."
  type        = string
}

variable "tags" {
  description = "Tags applied to all taggable resources (also set as provider default_tags)."
  type        = map(string)
  default     = {}
}

variable "s3_bucket_name" {
  description = "S3 bucket name (must be globally unique). If null, the module will generate a unique name using a random suffix."
  type        = string
  default     = null

  validation {
    condition = var.s3_bucket_name == null || (
      length(var.s3_bucket_name) >= 3 &&
      length(var.s3_bucket_name) <= 63 &&
      can(regex("^[a-z0-9][a-z0-9-]*[a-z0-9]$", var.s3_bucket_name)) &&
      !can(regex("--", var.s3_bucket_name))
    )
    error_message = "s3_bucket_name must be 3-63 chars, lowercase letters/numbers/hyphens, start/end with alphanumeric, and not contain consecutive hyphens."
  }
}

variable "s3_force_destroy" {
  description = "Whether to force-destroy the bucket (deletes all objects). Use with care."
  type        = bool
  default     = false
}

variable "s3_versioning_enabled" {
  description = "Enable S3 versioning."
  type        = bool
  default     = true
}

variable "s3_cors_rules" {
  description = "CORS rules for the S3 bucket."
  type = list(object({
    allowed_headers = optional(list(string), [])
    allowed_methods = list(string)
    allowed_origins = list(string)
    expose_headers  = optional(list(string), [])
    max_age_seconds = optional(number)
  }))

  default = [
    {
      allowed_methods = ["GET"]
      allowed_origins = ["*"]
    }
  ]

  validation {
    condition = alltrue([
      for r in var.s3_cors_rules : alltrue([
        for m in r.allowed_methods : contains(["GET", "PUT", "POST", "DELETE", "HEAD"], upper(m))
      ])
    ])
    error_message = "s3_cors_rules.allowed_methods may only contain: GET, PUT, POST, DELETE, HEAD."
  }
}
