terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# ECR repo for each app (example for python api)
resource "aws_ecr_repository" "api_python_flask" {
  name                 = "${var.org_prefix}/api-python-flask"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration { scan_on_push = true }
  encryption_configuration {
    encryption_type = "KMS"
    kms_key        = aws_kms_key.container_kms.arn
  }
  tags = var.tags
}

# KMS key for image encryption / signing (used by Cosign awskms://)
resource "aws_kms_key" "container_kms" {
  description             = "KMS key for container images and Cosign signing"
  key_usage               = "SIGN_VERIFY"
  customer_master_key_spec = "ECC_NIST_P256"
  deletion_window_in_days = 7
  multi_region            = false
  tags = var.tags
}

resource "aws_kms_alias" "container_kms_alias" {
  name          = "alias/${var.org_prefix}-cosign"
  target_key_id = aws_kms_key.container_kms.id
}

# GitHub OIDC provider
resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

# IAM role for GitHub Actions to push to ECR and use KMS
data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.github_owner}/${var.github_repo}:ref:refs/heads/main"]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "gha_ecr" {
  name               = "${var.org_prefix}-gha-ecr-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  tags               = var.tags
}

data "aws_iam_policy_document" "gha_policy" {
  statement {
    sid = "ECR"
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:CompleteLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:InitiateLayerUpload",
      "ecr:BatchGetImage",
      "ecr:PutImage",
      "ecr:DescribeRepositories",
      "ecr:BatchCheckLayerAvailability"
    ]
    resources = ["*"]
  }

  statement {
    sid = "KMS"
    effect = "Allow"
    actions = [
      "kms:Sign",
      "kms:GetPublicKey",
      "kms:DescribeKey"
    ]
    resources = [aws_kms_key.container_kms.arn]
  }
}

resource "aws_iam_policy" "gha_policy" {
  name   = "${var.org_prefix}-gha-ecr-policy"
  policy = data.aws_iam_policy_document.gha_policy.json
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.gha_ecr.name
  policy_arn = aws_iam_policy.gha_policy.arn
}
