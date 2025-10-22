package dockerfile

deny[msg] {
  input.instruction == "USER"
  not startswith(input.value, "1000")
  msg := "USER must be a non-root numeric UID (>=1000)"
}

deny[msg] {
  input.instruction == "FROM"
  not contains(input.value, "@sha256:")
  msg := "Base image must be pinned by digest"
}

deny[msg] {
  input.instruction == "RUN"
  contains(lower(input.value), "apk add")  # example: enforce pinned installs in separate policy
  not contains(input.value, "--no-cache")
  msg := "Package installs must be deterministic and no-cache"
}
