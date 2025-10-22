# VPC Egress Controls (Default-Deny for Containers)

## Goals
- Block all outbound by default; only allow approved dests (registry, updates, SaaS APIs).
- Provide **traceability** and **per-service control**.

## Patterns
1. **Private Subnets + NAT + Firewall:** Route private subnets to a central **NAT Gateway** behind **AWS Network Firewall**.
2. **VPC Endpoints (PrivateLink):** For AWS services (ECR, S3, STS), use interface/gateway endpoints. Add **endpoint policies** to restrict paths.
3. **DNS Control:** Route 53 Resolver with outbound rules → DNS firewall domains allowlist/denylist.
4. **Registry Egress:** Allow only `*.dkr.ecr.*.amazonaws.com` and your approved mirrors.
5. **Kubernetes Layer:** Use `NetworkPolicy` default-deny + **egress** rules per namespace/service. 

## Minimal Allowlist for CI/Runtime
- `sts.amazonaws.com` (OIDC role)
- `ecr.[region].amazonaws.com` and `*.dkr.ecr.[region].amazonaws.com`
- Your SIEM/log/metrics endpoints
- Time sync/NTP

## Terraform Hints
- Route tables → Network Firewall endpoint.
- DNS firewall domain lists → associate to VPC.
- Endpoint policies on S3/ECR to restrict repos/paths.
