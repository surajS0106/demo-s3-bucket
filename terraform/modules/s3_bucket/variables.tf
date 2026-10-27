variable "project" {
  description = "Project/application identifier used for naming."
  type        = string
}

variable "environment" {
  description = "Environment name (dev/staging/prod)."
  type        = string
}

variable "bucket_name" {
  description = "Optional explicit bucket name. If null, a name will be generated."
  type        = string
  default     = null
}

variable "force_destroy" {
  description = "Whether to force-destroy the bucket (deletes all objects)."
  type        = bool
  default     = false
}

variable "versioning_enabled" {
  description = "Enable S3 versioning."
  type        = bool
  default     = true
}

variable "cors_rules" {
  description = "CORS rules for the S3 bucket."
  type = list(object({
    allowed_headers = optional(list(string), [])
    allowed_methods = list(string)
    allowed_origins = list(string)
    expose_headers  = optional(list(string), [])
    max_age_seconds = optional(number)
  }))
  default = []
}

variable "tags" {
  description = "Tags to apply to resources."
  type        = map(string)
  default     = {}
}
