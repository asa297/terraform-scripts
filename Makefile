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

# =========================================== Create Worload Identity Pool ===========================================
# --- Configuration ---
CREATE_WIP_FOR_CI_CD_DIR := scripts/create-wip-for-cicd

create-wip-for-cicd-init:
	@echo "🚀 Initializing Terraform for Workload Identity Pool creation in [$(CREATE_WIP_FOR_CI_CD_DIR)]..."
	terraform -chdir=$(CREATE_WIP_FOR_CI_CD_DIR) init
create-wip-for-cicd-plan:
	@echo "📖 Creating execution plan for Workload Identity Pool in [$(CREATE_WIP_FOR_CI_CD_DIR)]..."
	terraform -chdir=$(CREATE_WIP_FOR_CI_CD_DIR) plan -var-file="terraform.tfvars"
create-wip-for-cicd-apply:
	@echo "✅ Applying configuration for Workload Identity Pool in [$(CREATE_WIP_FOR_CI_CD_DIR)]..."
	terraform -chdir=$(CREATE_WIP_FOR_CI_CD_DIR) apply -var-file="terraform.tfvars"
create-wip-for-cicd-destroy:
	@echo "🔥 WARNING: This will destroy the Workload Identity Pool and all its resources!"
	terraform -chdir=$(CREATE_WIP_FOR_CI_CD_DIR) destroy -var-file="terraform.tfvars"