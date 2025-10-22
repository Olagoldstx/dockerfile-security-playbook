# Threat Model (STRIDE-lite)

**Assets:** Source code, Dockerfiles, registry creds, built images, secrets, SBOM/attestations.
**Trust boundaries:** Developer laptop ↔ CI ↔ Registry ↔ Runtime.

## Risks & Controls
- **Supply-chain compromise:** pin digests, restrict registries, verify signatures, use provenance.
- **Leaky layers (secrets):** secret scanning, `.dockerignore`, no inline creds.
- **Privilege escalation:** non‑root USER, drop caps, seccomp, read‑only FS.
- **Lateral movement:** NetworkPolicy default‑deny, mTLS, egress proxy.
- **Vulns in base:** patch SLAs, Trivy nightly scans, base image rebuilds on CVE alerts.
