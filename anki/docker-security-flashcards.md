# Anki – Docker Security

Q: Why pin base images by digest?
A: Prevent supply‑chain drift; ensure reproducibility.

Q: What makes an image “runnable as non‑root”?
A: `USER` non‑root UID, drop caps, read‑only FS, writable tmp dirs only.

Q: What are mandatory CI artifacts before push?
A: SBOM, scan report (0 CRITICAL), signature, provenance.
