# Hands‑On Labs

## Lab 1 – Harden a Dockerfile
1. Start from `apps/api-python-flask/Dockerfile` (intentionally flawed).
2. Run `make policy.check` → see failures.
3. Fix: add multi‑stage, set USER, remove curl/build tools, add HEALTHCHECK.

## Lab 2 – SBOM + Scan + Sign
```bash
make sbom APP=api-python-flask     # syft → sbom/
make scan APP=api-python-flask     # trivy
make sign APP=api-python-flask     # cosign sign
make verify APP=api-python-flask   # cosign verify
```

## Lab 3 – Network Segmentation (Compose + K8s)
- Bring up `platform/compose/dev-stack.yaml`. Verify `frontend` cannot egress internet except via proxy.
- Apply `platform/k8s/networkpolicy.yaml` and test pod‑to‑pod reachability with `netshoot`.
