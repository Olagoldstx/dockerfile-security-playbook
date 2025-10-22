# Checklists

## Dockerfile Review (pre-merge)
- [ ] FROM uses approved base and pinned digest
- [ ] Multi‑stage used; no dev tools in final image
- [ ] `USER` non‑root set; `WORKDIR` explicit
- [ ] `.dockerignore` present and sane (no secrets)
- [ ] `HEALTHCHECK` defined
- [ ] Deterministic installs (hash/pin versions)
- [ ] No `apk add curl && rm -rf /var/cache/apk/*` without pinning
- [ ] No SSH, compilers, package managers in final image
- [ ] Entrypoint is non‑privileged script

## CI Gates
- [ ] Conftest passed (Dockerfile/K8s/Compose)
- [ ] SBOM generated and stored
- [ ] Trivy scan: 0 CRITICAL vulns
- [ ] Cosign sign + verify
- [ ] Attestation uploaded

## Runtime Readiness
- [ ] PodSecurity + seccomp set
- [ ] readOnlyRootFilesystem + tmp volume
- [ ] NetworkPolicy default‑deny + explicit egress
- [ ] Resource limits/requests set
