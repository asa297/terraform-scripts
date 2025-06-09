# =========================================== initialize GCP Project ===========================================
# --- Configuration ---
INIT_PROJECT_DIR := scripts/init-project

init-project-init:
	@echo "🚀 Initializing Terraform for project creation in [$(INIT_PROJECT_DIR)]..."
	terraform -chdir=$(INIT_PROJECT_DIR) init

init-project-plan:
	@echo "📖 Creating execution plan for new project in [$(INIT_PROJECT_DIR)]..."
	terraform -chdir=$(INIT_PROJECT_DIR) plan -var-file="terraform.tfvars"

init-project-apply:
	@echo "✅ Applying configuration for new project in [$(INIT_PROJECT_DIR)]..."
	terraform -chdir=$(INIT_PROJECT_DIR) apply -var-file="terraform.tfvars"

init-project-destroy:
	@echo "🔥 WARNING: This will destroy the project and all its resources!"
	terraform -chdir=$(INIT_PROJECT_DIR) destroy -var-file="terraform.tfvars"
