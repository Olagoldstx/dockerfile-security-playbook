# Dockerfile Security Playbook – Org‑Wide Adoption (Network × Security Collaboration)

> **Analogy:** Treat your Docker build system like a factory. Dockerfiles are the *assembly instructions*;
> base images are the *raw materials*; CI is the *robotic line*; your registry is the *warehouse*; and
> runtime (K8s/ECS/VM) is the *showroom*. **Security** is the QA team plus the safety inspectors.
> We design gates so bad parts never ship, and good parts are traceable end‑to‑end.

## Who is this for?
- Security leaders (you), Cloud Security Architects, Platform/SRE, App/Dev, and Network teams adopting Dockerfiles.
- Goal: a **repeatable, secure-by-default** pipeline from Day 0 (design) to Day 2+ (operations).

## Repo Map
```text
dockerfile-security-playbook/
├─ apps/
│  ├─ api-python-flask/            # Python API (multi-stage, non-root, distroless)
│  ├─ api-node-express/            # Node.js API
│  ├─ web-static-nginx/            # Static site served by NGINX (rootless variant)
│  └─ svc-go/                      # Go service (scratch/distroless)
├─ platform/
│  ├─ base-images/                 # Hardened base images + policies
│  ├─ compose/                     # Local dev networks + demos
│  └─ k8s/                         # K8s manifests: NetworkPolicy, PodSecurity, HPA, etc.
├─ ci/
│  ├─ github-actions/              # Workflows for build → scan → sign → attest → push
│  └─ conftest/                    # OPA policies to lint Dockerfiles
├─ docs/
│  ├─ THREAT-MODEL.md
│  ├─ RACI.md
│  ├─ POLICY.md
│  ├─ CHECKLISTS.md
│  ├─ LABS.md
│  └─ ARCHITECTURE.mmd             # Mermaid diagrams
├─ anki/
│  └─ docker-security-flashcards.md
├─ tools/
│  ├─ pre-commit/.pre-commit-config.yaml
│  ├─ scripts/                     # Helper scripts: SBOM, Trivy, Cosign, attestations
│  └─ .dockerignore.templates/
└─ Makefile
```

## Security Department (You) – End‑to‑End Responsibilities
1. **Day 0 (Design):** Approve base images, lock suppliers (registries), define policy‑as‑code, set up secrets mgmt.
2. **Day 1 (Build):** Enforce Dockerfile lint (OPA/Conftest), SAST, SBOM (Syft), vulnerability scan (Trivy).
3. **Day 1.5 (Governance):** Require image signing (Cosign) and provenance attestation (in‑toto/SLSA‑style).
4. **Day 2 (Run):** Mandate non‑root, read‑only FS, drop Linux capabilities, seccomp/apparmor/profiles.
5. **Day 2 (Network):** Default‑deny **NetworkPolicy**, egress control, service‑to‑service mTLS, DNS allowlists.
6. **Day N (Operate):** Continuous patch SLAs, CVE triage playbooks, runtime detection (Falco/eBPF), drift control.

## Collaboration with Network Team
- **Shared contract:** Security defines *guardrails*; Network provides *segmentation and egress control*.
- Use **compose** networks locally; enforce **K8s NetworkPolicy** in cluster; central **egress proxies** in prod.
- Observability: flow logs + IDS. Change windows: registry, egress, and DNS blocks are **change-controlled**.

## Hands‑On Path (Quick Start)
```bash
# 1) Run the local demo (build, scan, sign) for the Flask API
make bootstrap             # installs hooks/tools in a dev container if desired
make build APP=api-python-flask
make scan  APP=api-python-flask
make sbom  APP=api-python-flask
make sign  APP=api-python-flask

# 2) Compose up a local network demo (frontend ↔ api ↔ db with egress proxy)
docker compose -f platform/compose/dev-stack.yaml up --build

# 3) Validate policies
make policy.check          # OPA/Conftest: Dockerfile, K8s, compose
```

## Mermaid – High-Level Flow
```mermaid
flowchart LR
  Dev[Developer] -->|git push| CI[CI: Build/Scan/Sign]
  Sec[Security (You)] -->|OPA policies| CI
  CI -->|Signed image + SBOM + Attestations| REG[(Private Registry)]
  REG -->|Deploy| RT[Runtime (K8s/ECS)]
  Net[Network Team] -->|Egress allowlists + NetPolicies| RT
  RT -->|Alerts| SOC[(SOC/SIEM)]
```

## What’s in this repo?
- **Four secure example apps** with hardened Dockerfiles.
- **OPA/Conftest policies** to block dangerous Dockerfile patterns.
- **GitHub Actions** pipelines: build → SBOM → scan → sign → attest → push.
- **K8s** hardening: **NetworkPolicy**, **Pod Security**, **seccomp**, **readOnlyRootFilesystem**.
- **Docs**: Threat model, policy, checklists, RACI, and hands‑on labs.

---

### How to use this repo in your org
1. Fork → customize base image list and allowed registries.
2. Point Actions to your own registry (ECR/ACR/GCR/Harbor).
3. Roll out pre‑commit + CI gates to all teams.
4. Mandate “no deploy unless signed + policy‑passing + SBOM present”.

> **Definition of Done (per image):** Passed Conftest, generated SBOM, no CRITICAL vulns, signed with Cosign, provenance attached, running non‑root with network policy applied.


### Cloud: AWS ECR + KMS + OIDC
See **docs/ECR_SETUP.md** (CI to ECR with KMS signing) and **docs/VPC_EGRESS.md** (egress controls).
