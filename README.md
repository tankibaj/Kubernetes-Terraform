# Manage Kubernetes resources using Terraform

[TOC]

``<br/>

## Prerequisites

- [MicroK8s](https://microk8s.io/)
- [Kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Terraform](https://www.terraform.io/downloads.html)

<br/>

## Quick Start

#### Enable Ingress

SSH into MicroK8s node and run:

  ```bash
  microk8s enable ingress
  ```

<br/>

#### Enable Storage

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

<br/>


#### Test Ingress

- Verify ingress

  ```bash
  ❯ kubectl get ingress -n workspace
  
  # Output
  NAME     CLASS    HOSTS   ADDRESS     PORTS   AGE
  whoami   <none>   *       127.0.0.1   80      37s
  ```
- Curl `/` path

  ```bash
  ❯ curl 192.168.0.16

  # Output
  Hostname: whoami-55697b469f-9slbk
  IP: 127.0.0.1
  IP: ::1
  IP: 10.1.128.215
  IP: fe80::d05d:68ff:fee1:4ead
  RemoteAddr: 10.1.128.204:43310
  GET / HTTP/1.1
  Host: 192.168.0.16
  User-Agent: curl/7.64.1
  Accept: */*
  X-Forwarded-For: 192.168.0.9
  X-Forwarded-Host: 192.168.0.16
  X-Forwarded-Port: 80
  X-Forwarded-Proto: http
  X-Real-Ip: 192.168.0.9
  X-Request-Id: af140612331666beb914fd93752e29e0
  X-Scheme: http
  ```

- Curl `/dog` path

  ```bash
  ❯ curl 192.168.0.16/dog

  # Output
  PAGE: serving DOG
  HOST NAME: httpinfo-56fc4cbfcd-7r5tk
  HOST IP: 10.1.128.219
  REMOTE IP: 10.1.128.204
  SERVER PORT: 80
  REMOTE_PORT: 60648
  PROTOCOL: HTTP/1.1
  USER AGENT: curl/7.64.1
  REQUEST TIME: 1621044126
  REQUEST URI: /dog
  HTTP_ACCEPT: */*
  ```

- Curl host

  ```bash
  ❯ curl microk8s.test/cat
  
  # Output
  PAGE: serving CAT
  HOST NAME: httpinfo-56fc4cbfcd-rwrbq
  HOST IP: 10.1.128.218
  REMOTE IP: 10.1.128.204
  SERVER PORT: 80
  REMOTE_PORT: 50036
  PROTOCOL: HTTP/1.1
  USER AGENT: curl/7.64.1
  REQUEST TIME: 1621044034
  REQUEST URI: /cat
  HTTP_ACCEPT: */*
  ```

<br/>

#### Test PVC

- Verify PV

  ```bash
  ❯ kubectl get pv

  # Output
  NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                      STORAGECLASS        REASON   AGE
  pvc-aa06b811-44c5-47ec-bb35-a4b311922c77   1Gi        RWO            Delete           Bound    workspace/nginx-pv-claim   microk8s-hostpath            50m
  ```

- Verify PVC

  ```bash
  ❯ kubectl get pvc -n workspace
  
  # Output
  NAME             STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS        AGE
  nginx-pv-claim   Bound    pvc-aa06b811-44c5-47ec-bb35-a4b311922c77   1Gi        RWO            microk8s-hostpath   33m
  ```


- Check PV Host Path

  ```bash
  HOST_PATH=$(kubectl get pods -l k8s-app=hostpath-provisioner -o jsonpath="{.items[0].metadata.name}" -n kube-system)
  ```
  
  ```bash
  ❯ kubectl describe -n kube-system pod $HOST_PATH | grep PV_DIR

  # Output
  PV_DIR:     /var/snap/microk8s/common/default-storage
  ```

- Pod name environment variable

  ```bash
  POD_NAME=$(kubectl get pod -l App=nginx-pvc-test -o jsonpath="{.items[0].metadata.name}" -n workspace)
  ```

  

- Create a `index.html` file in the mounted PVC

  ```bash
  kubectl -n workspace exec $POD_NAME -- sh -c 'echo "Hello MicroK8s!!!" > /usr/share/nginx/html/index.html'
  ```

- Curl pvc host

  ```bash
  ❯ curl pvc.microk8s.test
  
  # Output
  Hello MicroK8s!!!
  ```

  