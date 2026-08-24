include default.mk

.PHONY: build
build: ## Build the opcache_exporter binary
	go build -o opcache_exporter ./cmd/exporter
