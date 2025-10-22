# AWS ECR + KMS + GitHub OIDC (Cosign) – Setup Guide

## 1) Deploy IaC
```bash
cd aws/terraform
terraform init
terraform apply -auto-approve   -var region=us-east-1   -var org_prefix=acme   -var github_owner=olagoldstx   -var github_repo=dockerfile-security-playbook
```
Outputs:
- `ecr_repo_uri_api_python_flask`
- `kms_key_arn`
- `github_role_arn`

## 2) Add GitHub Actions secrets (in your repo settings)
- `AWS_ROLE_TO_ASSUME` = output `github_role_arn`
- `AWS_REGION` = your region (e.g., `us-east-1`)
- (Optional) `ECR_REPO_API` = output `ecr_repo_uri_api_python_flask`

## 3) CI will:
- assume the OIDC role,
- build the image,
- push to ECR,
- **sign with KMS** via `awskms://alias/acme-cosign`.
