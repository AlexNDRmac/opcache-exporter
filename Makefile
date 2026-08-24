include default.mk

.PHONY: build
build: ## Build the opcache_exporter binary
	[ -d bin ] || mkdir bin
	go build -o bin/opcache_exporter ./cmd/exporter
