output "ecr_repo_uri_api_python_flask" {
  value = aws_ecr_repository.api_python_flask.repository_url
}
output "kms_key_arn" {
  value = aws_kms_key.container_kms.arn
}
output "github_role_arn" {
  value = aws_iam_role.gha_ecr.arn
}
