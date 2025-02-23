.PHONY: help install-% delete-%

# Get current context
CURRENT_CONTEXT := $(shell kubectl config current-context)

# Base directory for k8s configurations
K8S_BASE := k8s/infra

help: ## Show this help message
	@echo 'Usage:'
	@echo '  make install-TYPE NAME   Install specific component (e.g., make install-controller cert-manager)'
	@echo '  make delete-TYPE NAME    Delete specific component (e.g., make delete-controller cert-manager)'
	@echo ''
	@echo 'Current context: $(CURRENT_CONTEXT)'

install-%: ## Install specific component
	@if [ -z "$(NAME)" ]; then \
		echo "Error: NAME is required. Usage: make install-$* NAME=<name>"; \
		exit 1; \
	fi
	@echo "Installing $(K8S_BASE)/$*/$(NAME) in context $(CURRENT_CONTEXT)"
	kustomize build --enable-helm $(K8S_BASE)/$*/$(NAME) | kubectl apply -f -

delete-%: ## Delete specific component
	@if [ -z "$(NAME)" ]; then \
		echo "Error: NAME is required. Usage: make delete-$* NAME=<name>"; \
		exit 1; \
	fi
	@echo "Deleting $(K8S_BASE)/$*/$(NAME) from context $(CURRENT_CONTEXT)"
	kustomize build --enable-helm $(K8S_BASE)/$*/$(NAME) | kubectl delete -f -
