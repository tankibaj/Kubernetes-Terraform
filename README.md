Manage Kubernetes resources using Terraform

* [Prerequisites](#prerequisites)
* [Quick Start](#quick-start)
    * [Config host](#config-host)
        * [Open host file](#open-host-file)
        * [Add following lines to host file](#add-following-lines-to-host-file)
    * [Enable MicroK8s Addons](#enable-microk8s-addons)
        * [Enable Ingress](#enable-ingress)
        * [Enable PV](#enable-pv)
    * [Provision infrastructure](#provision-infrastructure)
        * [Prepare your working directory for other terrafrom commands](#prepare-your-working-directory-for-other-terrafrom-commands)
        * [Show changes required by the current configuration](#show-changes-required-by-the-current-configuration)
        * [Create infrastructure](#create-infrastructure)
    * [Ingress test](#ingress-test)
        * [Verify ingress](#verify-ingress)
        * [Curl / path](#curl--path)
        * [Curl /dog path](#curl-dog-path)
        * [Curl host](#curl-host)
    * [Persistent Volume Claim test](#persistent-volume-claim-test)
        * [Verify PV](#verify-pv)
        * [Verify PVC](#verify-pvc)
        * [Check PV Host Path](#check-pv-host-path)
        * [Pod name environment variable](#pod-name-environment-variable)
        * [Create a index\.html file in the mounted PVC](#create-a-indexhtml-file-in-the-mounted-pvc)
        * [Curl pvc host](#curl-pvc-host)
    * [Monitoring test](#monitoring-test)
        * [Grafana URL](#grafana-url)
        * [Prometheus URL](#prometheus-url)

<br/>

# Prerequisites

- [MicroK8s](https://microk8s.io/)
- [Kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Terraform](https://www.terraform.io/downloads.html)


<br/>

# Quick Start

### Config host

- ##### Open host file

  ```bash
  vim /etc/hosts
  ```

- ##### Add following lines to host file

  ```text
  <your_microk8s_ip>    microk8s.test
  <your_microk8s_ip>    pvc.microk8s.test
  <your_microk8s_ip>    monitoring.microk8s.test
  <your_microk8s_ip>    prometheus.microk8s.test
  ```
  
  > In my case MicroK8S node IP is `192.168.0.16`

<br/>

### Enable MicroK8s Addons

- ##### Enable Ingress

  SSH into MicroK8s node and run:

  ```bash
  microk8s enable ingress
  ```

- ##### Enable PV

  SSH into MicroK8s node and run:

  ```bash
  microk8s enable storage
  ```

<br/>

### Provision infrastructure

- ##### Prepare your working directory for other terrafrom commands

  ```
  terraform init
  ```

- ##### Show changes required by the current configuration

  ```
  terraform plan
  ```

- ##### Create infrastructure

  ```
  apply -auto-approve
  ```

<br/>


### Ingress test 

- ##### Verify ingress

  ```bash
  ❯ kubectl get ingress -n workspace
  
  # Output
  NAME     CLASS    HOSTS   ADDRESS     PORTS   AGE
  whoami   <none>   *       127.0.0.1   80      37s
  ```
- ##### Curl `/` path

  ```bash
  ❯ curl -H 'Host: microk8s.test' 192.168.0.16

  # Output
  Hostname: whoami-55697b469f-p4xwr
  IP: 127.0.0.1
  IP: ::1
  IP: 10.1.128.229
  IP: fe80::ecce:d0ff:fe86:90df
  RemoteAddr: 10.1.128.204:55110
  GET / HTTP/1.1
  Host: microk8s.test
  User-Agent: curl/7.64.1
  Accept: */*
  X-Forwarded-For: 192.168.0.9
  X-Forwarded-Host: microk8s.test
  X-Forwarded-Port: 80
  X-Forwarded-Proto: http
  X-Real-Ip: 192.168.0.9
  X-Request-Id: e4eea796b18efb0a1198344e9fc892c9
  X-Scheme: http
  ```

- ##### Curl `/dog` path

  ```bash
  ❯ curl -H 'Host: microk8s.test' 192.168.0.16/dog

  # Output
  PAGE: serving DOG
  HOST NAME: httpinfo-56fc4cbfcd-b9ppv
  HOST IP: 10.1.128.220
  REMOTE IP: 10.1.128.204
  SERVER PORT: 80
  REMOTE_PORT: 59414
  PROTOCOL: HTTP/1.1
  USER AGENT: curl/7.64.1
  REQUEST TIME: 1621106397
  REQUEST URI: /dog
  HTTP_ACCEPT: */*
  ```

- ##### Curl host

  ```bash
  ❯ curl -H 'Host: microk8s.test' 192.168.0.16/cat
  
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

### Persistent Volume Claim test

- ##### Verify PV

  ```bash
  ❯ kubectl get pv

  # Output
  NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                      STORAGECLASS        REASON   AGE
  pvc-aa06b811-44c5-47ec-bb35-a4b311922c77   1Gi        RWO            Delete           Bound    workspace/nginx-pv-claim   microk8s-hostpath            50m
  ```

- ##### Verify PVC

  ```bash
  ❯ kubectl get pvc -n workspace
  
  # Output
  NAME             STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS        AGE
  nginx-pv-claim   Bound    pvc-aa06b811-44c5-47ec-bb35-a4b311922c77   1Gi        RWO            microk8s-hostpath   33m
  ```


- ##### Check PV Host Path

  ```bash
  HOST_PATH=$(kubectl get pods -l k8s-app=hostpath-provisioner -o jsonpath="{.items[0].metadata.name}" -n kube-system)
  ```

  ```bash
  ❯ kubectl describe -n kube-system pod $HOST_PATH | grep PV_DIR

  # Output
  PV_DIR:     /var/snap/microk8s/common/default-storage
  ```

- ##### Pod name environment variable

  ```bash
  POD_NAME=$(kubectl get pod -l App=nginx-pvc-test -o jsonpath="{.items[0].metadata.name}" -n workspace)
  ```

  

- ##### Create a `index.html` file in the mounted PVC

  ```bash
  kubectl -n workspace exec $POD_NAME -- sh -c 'echo "Hello MicroK8s!!!" > /usr/share/nginx/html/index.html'
  ```

- ##### Curl pvc host

  ```bash
  ❯ curl -H 'Host: pvc.microk8s.test' 192.168.0.16
  
  # Output
  Hello MicroK8s!!!
  ```


<br/>

### Monitoring test

- ##### Grafana URL

  [monitoring.microk8s.test](prometheus.microk8s.test)

- ##### Prometheus URL

  [prometheus.microk8s.test](prometheus.microk8s.test)   

