# RACI – Org Dockerfile Adoption

| Task | Security | Network | Platform/SRE | App/Dev |
|------|----------|---------|--------------|---------|
| Define base image catalog | **A/R** | C | C | I |
| CI policy gates (OPA, scans) | **A/R** | C | R | C |
| Registry access & signing | **A/R** | I | R | I |
| NetworkPolicy & egress | C | **A/R** | R | C |
| Secrets mgmt (Vault/KMS) | **A/R** | I | R | C |
| Runtime profiles (seccomp/AppArmor) | **A/R** | I | R | C |
| CVE triage & patch SLAs | **A/R** | I | C | C |
| App Dockerfiles | C | I | C | **A/R** |
*A=Accountable, R=Responsible, C=Consulted, I=Informed*
