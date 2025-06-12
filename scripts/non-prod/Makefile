# =========================================== initialize GCP Project ===========================================
# --- Configuration ---
INIT_PROJECT_DIR := ./init-project

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
INIT_CI_CD_DIR := ./init-cicd

init-cicd-init:
	@echo "🚀 Initializing Terraform for Workload Identity Pool creation in [$(INIT_CI_CD_DIR)]..."
	terraform -chdir=$(INIT_CI_CD_DIR) init
init-cicd-plan:
	@echo "📖 Creating execution plan for Workload Identity Pool in [$(INIT_CI_CD_DIR)]..."
	terraform -chdir=$(INIT_CI_CD_DIR) plan -var-file="terraform.tfvars"
init-cicd-apply:
	@echo "✅ Applying configuration for Workload Identity Pool in [$(INIT_CI_CD_DIR)]..."
	terraform -chdir=$(INIT_CI_CD_DIR) apply -var-file="terraform.tfvars"
init-cicd-destroy:
	@echo "🔥 WARNING: This will destroy the Workload Identity Pool and all its resources!"
	terraform -chdir=$(INIT_CI_CD_DIR) destroy -var-file="terraform.tfvars"

# =========================================== Init Cloud Run ===========================================
# --- Configuration ---
INIT_CLOUD_RUN_DIR := ./init-cloud-run
init-cloud-run-init:
	@echo "🚀 Initializing Terraform for Cloud Run setup in [$(INIT_CLOUD_RUN_DIR)]..."
	terraform -chdir=$(INIT_CLOUD_RUN_DIR) init
init-cloud-run-plan:
	@echo "📖 Creating execution plan for Cloud Run setup in [$(INIT_CLOUD_RUN_DIR)]..."
	terraform -chdir=$(INIT_CLOUD_RUN_DIR) plan -var-file="terraform.tfvars"
init-cloud-run-apply:
	@echo "✅ Applying configuration for Cloud Run setup in [$(INIT_CLOUD_RUN_DIR)]..."
	terraform -chdir=$(INIT_CLOUD_RUN_DIR) apply -var-file="terraform.tfvars"
init-cloud-run-destroy:
	@echo "🔥 WARNING: This will destroy the Cloud Run service and all its resources!"
	terraform -chdir=$(INIT_CLOUD_RUN_DIR) destroy -var-file="terraform.tfvars"
