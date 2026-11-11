SHELL := /bin/bash
SERVICE ?= app
STACK ?=
SQL ?=
FORCE ?=

.DEFAULT_GOAL := help

.PHONY: help doctor init up down restart build logs ps shell test lint fmt db db-sql ci check-agents scan clean

help: ## Show this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nVibe Infra — container-first commands\n\n"} /^[a-zA-Z0-9_-]+:.*##/ {printf "  \033[36m%-16s\033[0m %s\n", $$1, $$2} END {printf "\nStack: $$(grep -E "^STACK=" project.env | cut -d= -f2)\n\n"}' $(MAKEFILE_LIST)

doctor: ## Validate podman, compose provider, stack, and env file
	@scripts/doctor.sh

init: ## Seed app/ from a stack template: make init STACK=python-fastapi
	@scripts/init.sh "$(STACK)" $(if $(FORCE),--force,)

up: ## Start app and database containers
	@scripts/dev-up.sh

down: ## Stop containers (keeps volumes)
	@scripts/dev-down.sh

restart: down up ## Restart containers

build: ## Rebuild the app image
	@scripts/compose.sh build

logs: ## Follow logs: make logs SERVICE=app
	@scripts/logs.sh "$(SERVICE)"

ps: ## Show container status
	@scripts/compose.sh ps

shell: ## Shell inside a container: make shell SERVICE=app|db
	@scripts/shell.sh "$(SERVICE)"

test: ## Run the stack test command inside the app container
	@scripts/test.sh

lint: ## Run the stack lint command inside the app container
	@scripts/lint.sh

fmt: ## Run the stack formatter inside the app container
	@scripts/fmt.sh

db: ## Interactive MariaDB client inside the DB container
	@scripts/db.sh

db-sql: ## Run one SQL statement: make db-sql SQL="SELECT 1;"
	@scripts/db.sh "$(SQL)"

ci: ## Run the full container CI locally (same as GitHub Actions)
	@scripts/ci-local.sh

check-agents: ## Verify the AI contract and all tool adapters
	@scripts/check-ai-config.sh

scan: ## Scan the working tree for secrets with gitleaks in Podman
	@scripts/scan.sh

clean: ## Stop containers and delete volumes
	@scripts/compose.sh down --volumes --remove-orphans
