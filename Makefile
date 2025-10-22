APP ?= api-python-flask
IMAGE ?= local/${APP}:dev

.PHONY: build scan sbom sign verify policy.check bootstrap

build:
	docker build -t $(IMAGE) apps/$(APP)

scan:
	trivy image --exit-code 1 --severity CRITICAL $(IMAGE) || true

sbom:
	syft packages $(IMAGE) -o json > sbom/$(APP).json || mkdir -p sbom && syft packages $(IMAGE) -o json > sbom/$(APP).json

sign:
	cosign sign --yes $(IMAGE)

verify:
	cosign verify $(IMAGE)

policy.check:
	conftest test --policy ci/conftest --all-namespaces apps/$(APP)/Dockerfile

bootstrap:
	@echo "Install dev tools (docker, trivy, syft, cosign, conftest) as needed."
