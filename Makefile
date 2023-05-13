config: githooks-install # Configure development environment

githooks-install: # Install git hooks configured in this repository
	echo "./scripts/githooks/pre-commit" > .git/hooks/pre-commit
	chmod +x .git/hooks/pre-commit

detect-os: # Detect operating system and print export variables
	./scripts/detect-operating-system.sh

test: # Run the test suite
	./scripts/detect-operating-system.test.sh

# ==============================================================================

help: # List Makefile targets
	@awk 'BEGIN {FS = ":.*?# "} /^[ a-zA-Z0-9_-]+:.*? # / {printf "\033[36m%-41s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST) | sort

list-variables: # List all the variables available to make
	@$(foreach v, $(sort $(.VARIABLES)),
		$(if $(filter-out default automatic, $(origin $v)),
			$(if $(and $(patsubst %_PASSWORD,,$v), $(patsubst %_PASS,,$v), $(patsubst %_KEY,,$v), $(patsubst %_SECRET,,$v)),
				$(info $v=$($v) ($(value $v)) [$(flavor $v),$(origin $v)]),
				$(info $v=****** (******) [$(flavor $v),$(origin $v)])
			)
		)
	)

.DEFAULT_GOAL := help
.EXPORT_ALL_VARIABLES:
.NOTPARALLEL:
.ONESHELL:
.PHONY: *
MAKEFLAGS := --no-print-director
SHELL := /bin/bash
ifeq (true, $(shell [[ "$(DEBUG)" =~ ^(true|yes|y|on|1|TRUE|YES|Y|ON)$$ ]] && echo true))
	.SHELLFLAGS := -cex
else
	.SHELLFLAGS := -ce
endif

.SILENT: \
	config \
	detect-os \
	githooks-install \
	test
