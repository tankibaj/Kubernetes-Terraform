# Manage Kubernetes resources using Terraform

<br/>

## Prerequisites

- [MicroK8s](https://microk8s.io/)
- [Kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Terraform](https://www.terraform.io/downloads.html)

<br/>

## Quick Start

#### Provision infrastructure

- Prepare your working directory for other terrafrom commands.

  ```
  terraform init
  ```

- Show changes required by the current configuration.

  ```
  terraform plan
  ```

- Create infrastructure.

  ```
  apply -auto-approve
  ```

