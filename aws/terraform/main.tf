# ─────────────────────────────────────────────────────────────
# 🔐 KMS: split keys for ECR (symmetric) and Cosign (asymmetric)
# ─────────────────────────────────────────────────────────────

# Symmetric key for ECR encryption-at-rest
resource "aws_kms_key" "ecr_kms" {
  description              = "KMS key for ECR image encryption"
  key_usage                = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"

  tags = {
    App   = "dockerfile-security-playbook"
    Owner = "Security"
  }
}

# Asymmetric key for Cosign signing (image signatures/attestations)
resource "aws_kms_key" "cosign_kms" {
  description              = "KMS key for Cosign container signing"
  key_usage                = "SIGN_VERIFY"
  customer_master_key_spec = "ECC_NIST_P256"

  tags = {
    App   = "dockerfile-security-playbook"
    Owner = "Security"
  }
}

# Friendly alias for the Cosign signing key
resource "aws_kms_alias" "container_kms_alias" {
  name          = "alias/acme-cosign"
  target_key_id = aws_kms_key.cosign_kms.key_id
}

# ─────────────────────────────────────────────────────────────
# 🧺 ECR repository using the SYMMETRIC key
# ─────────────────────────────────────────────────────────────
resource "aws_ecr_repository" "api_python_flask" {
  name                 = "acme/api-python-flask"
  image_tag_mutability = "MUTABLE"

  encryption_configuration {
    encryption_type = "KMS"
    kms_key         = aws_kms_key.ecr_kms.arn # ← must be symmetric
  }

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    App   = "dockerfile-security-playbook"
    Owner = "Security"
  }
}

# (Optional) handy outputs
output "kms_key_arn_cosign" {
  description = "Asymmetric KMS key ARN used by Cosign (SIGN_VERIFY)"
  value       = aws_kms_key.cosign_kms.arn
}

output "kms_key_arn_ecr" {
  description = "Symmetric KMS key ARN used by ECR encryption"
  value       = aws_kms_key.ecr_kms.arn
}

output "ecr_repo_uri_api_python_flask" {
  description = "ECR repository URI for api-python-flask"
  value       = aws_ecr_repository.api_python_flask.repository_url
}
