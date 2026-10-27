# AWS S3 bucket (versioning + CORS) — OpenTofu

This stack provisions an Amazon S3 bucket with:
- Versioning
- CORS configuration
- Default encryption (SSE-S3 / AES256)
- Public access block (recommended default)

## Usage

1. Configure AWS credentials (AWS_PROFILE, env vars, or an IAM role).
2. From the `terraform/` directory:
   - `tofu init`
   - `tofu plan -var-file=environments/dev.tfvars`
   - `tofu apply -var-file=environments/dev.tfvars`

## Inputs

- `s3_bucket_name`: optional. If omitted, a unique name is generated as `{project}-{environment}-{random}`.
- `s3_cors_rules`: list of CORS rules.

## Notes

- If you set `s3_force_destroy=true`, destroying will delete **all objects and versions** in the bucket.
