# Container Security Policy (Build → Ship → Run)

**Scope:** All images built from Dockerfiles in company projects.

## Build
- Only use **approved base images** pinned by digest (e.g., `@sha256:...`). 
- **No secrets** in Dockerfile or layers. Use build args with caution; prefer vault/CI secrets.
- Enforce **multi‑stage** builds; final stage must be minimal (distroless/scratch if possible).
- Must run as **non‑root**: set `USER` to a dedicated UID and drop capabilities.

## Ship
- Every image must have:
  - **SBOM** (SPDX/CycloneDX).
  - **Vulnerability scan** result with **no CRITICAL** vulns (block on CRITICAL, warn on HIGH).
  - **Signature** (Cosign) and **provenance attestation** (in‑toto/SLSA‑style).

## Run
- **readOnlyRootFilesystem: true**, explicit `fsGroup`, and `runAsNonRoot: true`.
- Apply **NetworkPolicy** default‑deny; only required egress/ingress allowed.
- Set **seccomp** (runtime/default) and **AppArmor** profiles where supported.
- Centralized logging, metrics, and **runtime detection** (Falco/eBPF).

## Exceptions
- Time‑boxed, risk‑accepted with CVE ID, compensating controls, and remediation ETA.
