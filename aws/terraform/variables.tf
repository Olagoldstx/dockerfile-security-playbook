variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "org_prefix" {
  description = "Org prefix for resources"
  type        = string
  default     = "acme"
}

variable "github_owner" {
  description = "GitHub owner/org (e.g., olagoldstx)"
  type        = string
}

variable "github_repo" {
  description = "GitHub repo name (without owner)"
  type        = string
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = { "App" = "dockerfile-security-playbook", "Owner" = "Security" }
}
