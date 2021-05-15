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



#### Test NodePort service

```bash
❯ curl 192.168.0.16:30201

# Output sample
Hostname: whoami-55697b469f-9slbk
IP: 127.0.0.1
IP: ::1
IP: 10.1.128.215
IP: fe80::d05d:68ff:fee1:4ead
RemoteAddr: 192.168.0.16:49284
GET / HTTP/1.1
Host: 192.168.0.16:30201
User-Agent: curl/7.64.1
Accept: */*
```

