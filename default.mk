SHELL ?= /bin/bash
PARALLELISM := $(shell getconf _NPROCESSORS_ONLN)

# The directory that contains this file, which is also the repository root.
TOP := $(dir $(lastword $(MAKEFILE_LIST)))

.SILENT: ;               # no need for @
.ONESHELL: ;             # recipes execute in same shell
.NOTPARALLEL: ;          # wait for this target to finish
.EXPORT_ALL_VARIABLES: ; # send all vars to shell
Makefile: ;              # skip prerequisite discovery

# Run make help by default
.DEFAULT_GOAL = help

# ── Versioning ────────────────────────────────────────────────────────────────
#
# Derived from the nearest reachable git tag.
# Falls back to "dev" in shallow
# clones, detached HEADs without tags, or non-git directories.

VERSION ?= $(shell git describe --tags --always --dirty 2>/dev/null || echo dev)
COMMIT  ?= $(shell git rev-parse HEAD 2>/dev/null || echo unknown)
DATE    ?= $(shell date -u +%Y-%m-%d)

# help target prints LOGO and you can override this logo
# by defining LOGO variable in your Makefile before including default.mk
define LOGO
endef

.PHONY: help
help: ## Show this help message and exit
	echo "$${LOGO}"
	python3 -c "import re; \
	[[print(f'\033[36m{m[0]:<20}\033[0m {m[1]}') for m in re.findall(r'^([a-zA-Z_-]+):.*?## (.*)$$', open(makefile).read(), re.M)] for makefile in ('$(MAKEFILE_LIST)').strip().split()]"
