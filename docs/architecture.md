# Architecture Overview

## Purpose
This platform runs a Go backend microservice on Amazon EKS, backed by
RDS PostgreSQL, deployed through a CircleCI + CodeDeploy pipeline,
with SaltStack managing supporting EC2 infrastructure and AWS Backup
providing automated disaster recovery.

## Components

### Application Layer
- **Go service** (`cmd/service/main.go`) exposes `/health` and
  `/ready` endpoints consumed by Kubernetes liveness/readiness probes.
- **`internal/db`** handles RDS connectivity using credentials
  injected via environment variables, sourced from AWS Secrets
  Manager at deploy time (not hardcoded).

### Infrastructure Layer
- **Terraform** provisions the VPC, EKS cluster, RDS instance
  (Multi-AZ, 7-day backup retention), and Direct Connect gateway for
  hybrid on-prem connectivity.
- **AWS Backup** (`dr/backup-policy.tf`) adds a daily backup plan on
  top of RDS's native backups, with a 30-day retention lifecycle,
  for compliance-grade recovery point coverage.

### Provisioning Layer
- **SaltStack** (`salt/states/bastion/`) configures bastion/jump
  hosts: package installation, SSH hardening (no root login, no
  password auth), and a dedicated admin user — ensuring these
  supporting hosts don't drift from baseline over time.

### CI/CD Layer
- **CircleCI** (`.circleci/config.yml`): build/test -> build & push
  Docker image to ECR -> trigger AWS CodeDeploy deployment.
- **AWS CodeDeploy** (`codedeploy/appspec.yml`) manages the
  application lifecycle hooks (stop/start) on EC2-based deployment
  targets alongside the EKS deployment path.

### Monitoring Layer
- **CloudWatch alarms** watch RDS CPU utilization and free storage,
  alerting before capacity issues cause an outage.

## Data Flow
1. Developer pushes to `main` -> CircleCI runs Go tests.
2. On pass, Docker image builds and pushes to ECR.
3. CodeDeploy deployment triggers, rolling out the new version.
4. Kubernetes probes verify health/readiness before routing traffic.
5. AWS Backup runs nightly against RDS; CloudWatch alarms monitor
   ongoing resource health.
