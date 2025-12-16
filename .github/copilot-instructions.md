# Copilot / AI Agent Instructions for this repository

Purpose: Help an AI coding agent be immediately productive in this multi-cloud Terraform + Terragrunt repo.

- **Big picture:** This repo manages multi-cloud infrastructure (AWS, Azure, GCP) using Terraform modules and Terragrunt orchestration. Live configurations live under `infrastructure-live/stacks/` grouped by cloud -> env -> region. High-level templates and reusable module scaffolds live in `templates/` and `infrastructure-live/**/modules/`.

- **Key files to inspect (examples):**
  - [README.md](README.md)
  - [terragrunt.hcl](terragrunt.hcl)
  - [common.tfvars](common.tfvars)
  - [provider.tf](provider.tf)
  - [ansible/inventory.yaml](ansible/inventory.yaml)
  - [templates/module-gke.tmpl](templates/module-gke.tmpl)
  - [infrastructure-live/stacks/aws/dev/us-east-1/ecr/terragrunt.hcl](infrastructure-live/stacks/aws/dev/us-east-1/ecr/terragrunt.hcl)

- **Architecture notes (what you'll use):**
  - Terragrunt is used as the orchestration layer. Root `terragrunt.hcl` defines remote state (S3 + DynamoDB locks) and generated provider/version files.
  - Each stack folder contains a `terragrunt.hcl` that includes module references and `generate` blocks (Terragrunt can write `provider.tf` and `versions.tf`).
  - Modules are separated per-cloud under `infrastructure-live/stacks/*/modules` and templated content under `templates/`.
  - Ansible inventory is present for configuration/VM orchestration and uses the GCP dynamic plugin (see `ansible/inventory.yaml`).

- **Developer workflows & commands (explicit):**
  - To inspect or change generated provider/versions behavior, edit the root [terragrunt.hcl](terragrunt.hcl) `generate` blocks.
  - Typical Terragrunt flows (run from a specific stack/region directory):
    - `terragrunt init` then `terragrunt plan` — single-stack checks.
    - `terragrunt plan-all` / `terragrunt apply-all` — run across included stacks (use with caution).
  - Validate formatting: `terraform fmt -recursive` in module folders.
  - Validate Terraform: `terragrunt validate` or `terraform validate` in module directories.

- **Conventions and important patterns to preserve:**
  - Terragrunt is intentionally used to generate `provider.tf` and `versions.tf` at runtime; do not hard-delete generated files without confirming terragrunt behavior.
  - Remote state backend is S3 with DynamoDB locks (see `terragrunt.hcl`); maintain S3 key patterns `${path_relative_to_include()}/terraform.tfstate`.
  - Project-wide variables live in `common.tfvars` — reuse keys rather than adding conflicting vars in stack-level tfvars.

- **Integration points / secrets / runtime assumptions:**
  - AWS: provider region default is `us-east-1` via `terragrunt.hcl` generate block.
  - GCP: Ansible inventory uses a service account file path (see `ansible/inventory.yaml`); verify local developer paths before running automation.
  - CI/CD systems should have AWS credentials and the S3/DynamoDB resources for remote state.

- **When editing infra code, follow these steps:**
  1. Work in the specific stack folder under `infrastructure-live/stacks/<cloud>/<env>/<region>/`.
 2. Run `terragrunt init` then `terragrunt plan` locally to validate changes.
 3. Confirm remote-state keys and any `generate` outputs (provider/versions) are correct.

- **Examples of common edits an agent might perform:**
  - Add a new module reference: modify the stack `terragrunt.hcl` and reference a module from `infrastructure-live/stacks/*/modules` or `templates/`.
  - bump provider constraints: edit the `generate "versions"` block in root `terragrunt.hcl` so generated `versions.tf` gets updated for all stacks.

- **What NOT to change automatically:**
  - Don't remove or blindly rewrite generated files without adjusting the `generate` blocks in the `terragrunt.hcl` that created them.
  - Don't change remote backend S3 bucket or dynamodb table names without coordinating with the team/CI.

If anything here is unclear or you'd like a more detailed checklist for PRs / CI steps, tell me which area to expand (e.g., Terragrunt usage, module structure, or Ansible integration).
