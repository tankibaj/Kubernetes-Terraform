# Manage Kubernetes resources using Terraform

<br/>

## Prerequisites

- [MicroK8s](https://microk8s.io/)
- [Kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Terraform](https://www.terraform.io/downloads.html)

<br/>

## Quick Start


#### Enable PV storage

SSH into MicroK8s node and run:

```bash
microk8s enable storage
```

<br/>

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
❯ kubectl get ingress -n workspace

# Output Sample
NAME     CLASS    HOSTS   ADDRESS     PORTS   AGE
whoami   <none>   *       127.0.0.1   80      37s
```

```bash
❯ curl 192.168.0.16

# Output Sample
Hostname: whoami-55697b469f-9slbk
IP: 127.0.0.1
IP: ::1
IP: 10.1.128.215
IP: fe80::d05d:68ff:fee1:4ead
RemoteAddr: 10.1.128.204:37730
GET / HTTP/1.1
Host: 192.168.0.16
User-Agent: curl/7.64.1
Accept: */*
X-Forwarded-For: 192.168.0.9
X-Forwarded-Host: 192.168.0.16
X-Forwarded-Port: 80
X-Forwarded-Proto: http
X-Real-Ip: 192.168.0.9
X-Request-Id: 8352a0d04446e596ccb0acbb2c86883b
X-Scheme: http
```

