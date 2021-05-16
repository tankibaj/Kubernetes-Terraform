# Manage Kubernetes resources using Terraform

* [Prerequisites](#prerequisites)
* [Getting Started](#getting-started)
    * [Config host](#config-host)
        * [Open host file](#open-host-file)
        * [Add following lines to host file](#add-following-lines-to-host-file)
    * [MicroK8s Addons](#microk8s-addons)
        * [Enable Ingress](#enable-ingress)
        * [Enable PV](#enable-pv)
    * [Dynamic Volume Provisioning (NFS)](#dynamic-volume-provisioning-nfs)
        * [Mount NFS on Worker nodes](#mount-nfs-on-worker-nodes)
        * [Mount automatically on system startup](#mount-automatically-on-system-startup)
    * [Provision infrastructure](#provision-infrastructure)
        * [Prepare your working directory for other terrafrom commands](#prepare-your-working-directory-for-other-terrafrom-commands)
        * [Show changes required by the current configuration](#show-changes-required-by-the-current-configuration)
        * [Create infrastructure](#create-infrastructure)
    * [Ingress](#ingress)
        * [Verify ingress](#verify-ingress)
        * [Curl / path](#curl--path)
        * [Curl /dog path](#curl-dog-path)
        * [Curl /cat](#curl-cat)
    * [Persistent Volume](#persistent-volume)
      * [HostPath](#hostpath)
      * [NFS](#nfs)
    * [Monitoring](#monitoring)

<br/>

# Prerequisites

- [MicroK8s](https://microk8s.io/)
- [Kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Terraform](https://www.terraform.io/downloads.html)


<br/>

# Getting Started

### Config host

- ##### Open host file

  ```bash
  vim /etc/hosts
  ```

- ##### Add following lines to host file

  ```text
  <your_microk8s_ip>    microk8s.test
  <your_microk8s_ip>    monitoring.microk8s.test
  <your_microk8s_ip>    prometheus.microk8s.test
  <your_microk8s_ip>    hostpath.microk8s.test
  <your_microk8s_ip>    nfs.microk8s.test
  ```
  
  > In my case MicroK8S node IP is `192.168.0.16`

<br/>

### MicroK8s Addons

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

### Dynamic Volume Provisioning (NFS)

- ##### Mount NFS on Worker node

  ```bash
  sudo mount -t nfs 192.168.0.100:/home/naim/nfs /home/naim/nfs
  ```

- ##### Mount automatically on system startup

  ```bash
  sudo bash -c "echo '192.168.0.100:/home/naim/nfs /home/naim/nfs nfs4 defaults,_netdev 0 0'  | cat >> /etc/fstab"
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


### Ingress

- ##### Verify ingress

  ```bash
  kubectl get ingress -n workspace
  ```
- ##### Curl `/` path

  ```bash
  curl -H 'Host: microk8s.test' 192.168.0.16
  ```
  
- ##### Curl `/dog` path

  ```bash
  curl -H 'Host: microk8s.test' 192.168.0.16/dog
  ```
  
- ##### Curl `/cat`

  ```bash
  curl -H 'Host: microk8s.test' 192.168.0.16/cat
  ```

<br/>

### Persistent Volume

  ```bash
  kubectl get storageclass
  kubectl get pv
  kubectl get pvc -n workspace
  ```

- #### HostPath

  ```bash
  HOST_PATH=$(kubectl get pods -l k8s-app=hostpath-provisioner -o jsonpath="{.items[0].metadata.name}" -n kube-system)
  ```

  ```bash
  kubectl describe -n kube-system pod $HOST_PATH | grep PV_DIR
  ```
  
  ```bash
  HOSTPATH_POD_NAME=$(kubectl get pod -l App=hostpath-pvc-test -o jsonpath="{.items[0].metadata.name}" -n workspace)
  ```
  
  ```bash
  kubectl -n workspace exec $HOSTPATH_POD_NAME -- sh -c 'echo "Hello MicroK8s!!!" > /usr/share/nginx/html/index.html'
  ```
  
  ```bash
  curl -H 'Host: hostpath.microk8s.test' 192.168.0.16
  ```

- #### NFS

  ```bash
  NFS_PATH=$(kubectl get pods -l app=nfs-client-provisioner -o jsonpath="{.items[0].metadata.name}" -n kube-system)
  ```

  ```bash
  kubectl describe -n kube-system pod $NFS_PATH | grep NFS_PATH
  ```
  
  ```bash
  NFS_POD_NAME=$(kubectl get pod -l App=nfs-pvc-test -o jsonpath="{.items[0].metadata.name}" -n workspace)
  ```
  
  ```bash
  kubectl -n workspace exec $NFS_POD_NAME -- sh -c 'echo "Hello MicroK8s!!!" > /usr/share/nginx/html/index.html'
  ```
  
  ```bash
  curl -H 'Host: nfs.microk8s.test' 192.168.0.16
  ```


<br/>

### Monitoring

**Grafana URL:** [monitoring.microk8s.test](http://monitoring.microk8s.test)

**Prometheus URL:** [prometheus.microk8s.test](http://prometheus.microk8s.test)
