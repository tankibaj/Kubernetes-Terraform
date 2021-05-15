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



#### Test ClusterIP service

```bash
❯ kubectl get service -o wide -n workspace
# Output sample
NAME     TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE   SELECTOR
whoami   NodePort   10.152.183.14   <none>        80:30201/TCP   18m   App=whoami
```

```bash
❯ curl 192.168.0.16:30201


NAME     TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE   SELECTOR
whoami   ClusterIP   10.152.183.14   <none>        80/TCP    15m   App=whoami
```

