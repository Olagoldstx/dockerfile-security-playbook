# Push to GitHub (olagoldstx)

```bash
# from repo root
git init
git add .
git commit -m "feat: org-wide Dockerfile security playbook (ECR+KMS+OIDC)"
git branch -M main
git remote add origin https://github.com/olagoldstx/dockerfile-security-playbook.git
git push -u origin main
```
Then: add repo secrets `AWS_ROLE_TO_ASSUME` and `AWS_REGION`, and push again to trigger CI.
