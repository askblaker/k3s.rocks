# Install and set up

## Install a new Linux server with Docker

- Create a new remote VPS ("virtual private server").
- Deploy the latest Ubuntu LTS ("long term support") version. At the time of this writing it's `Ubuntu 20.04`.
- Connect to it via SSH, e.g.:

```bash
ssh root@172.173.174.175
```

- Define a server name using a subdomain of a domain you own, for example `dog.yourdomain.com`.
- Make sure the subdomain DNS records point to your VPS's IP address. Either all the desired subdomains, or use a wildcard. An A record from \*.dog.example.com to the VPS IP would work.
- Create a temporary environment variable with the name of the host to be used later, we will also set the email to be used with letsencrypt (using a fake/testing email here might cause it to fail) as well as the version of this guide.

- Set up your domain

```bash
export DOMAIN=dog.example.com
```

- Set up your email

```bash
export EMAIL=name@example.com
```

- Set up the server `hostname` if it is not provided. It is recommended that each node has a unique hostname.

```bash
export USE_HOSTNAME=my-new-hostname
```

```bash
echo $USE_HOSTNAME > /etc/hostname
hostname -F /etc/hostname
```

**Note**: If you are not a `root` user, you might need to add `sudo` to these commands. The shell will tell you when you don't have enough permissions. Note that `sudo` does not preserve environment variables by default, but this can be enabled via the `-E` flag.

- Install the latest updates, open-iscsi for longhorn and wireguard:

```bash
apt update && \
apt upgrade -y && \
apt install open-iscsi -y && \
apt install wireguard -y
```

## Get tools

These tools can be on any machine, including your local. But it needs to have kubectl installed. If you have activated kubernetes in your docker desktop installation, you already have it. The bash snippet below installs arkade and uses it to install the other tools. But you could just as well install them separately.

- Install [Arkade](https://github.com/alexellis/arkade), [Helm](https://helm.sh/docs/) and [Kubectl autocomplete](https://kubernetes.io/docs/tasks/tools/included/optional-kubectl-configs-bash-linux/):

```bash
curl -sLS https://dl.get-arkade.dev | sh && \
arkade get helm && \
mv /root/.arkade/bin/helm /usr/local/bin/ && \
arkade get kubectl && \
mv /root/.arkade/bin/kubectl /usr/local/bin/ && \
source <(kubectl completion bash) && \
echo "source <(kubectl completion bash)" >> ~/.bashrc
```

In K3S you have one or more master nodes and one or more worker nodes, but the manager nodes can also run workloads. For a high availability set up, it is often recommended to use 3 master nodes, but a single node will be fine for testing.

The first step is to configure one (or more) manager nodes.

## Get manifests / repo

** Note: ** You can just copy paste these manifests as you please, but to follow along with this guide, it is convenient to have them on disk.

```bash
git clone https://github.com/askblaker/k3s.rocks.git
```

### cat vs curl

If you prefer not to download them, you can also curl and pipe them directly into kubectl apply -f. Just replace the cat command, with a curl command with the correct url, like this:

#### cat

```bash
cat traefik-config.yaml | envsubst | kubectl apply -f -
```

#### curl

```
curl https://raw.githubusercontent.com/askblaker/k3s.rocks/main/manifests/traefik-config.yaml | envsubst | kubectl apply -f -
```

## First master

**Note:** Remember to have your environment variables set!

Not that we also alter the default deployment of the traefik ingress controller, see [helm chart values](https://github.com/traefik/traefik-helm-chart/blob/v9.18.3/traefik/values.yaml) for all the other options. Even K3S internally uses a helmchartconfig, changes can be applied with vanilla kubectl as we do here.

### Goto manifests folder

```bash
cd k3s.rocks/manifests/
```

### Install k3s

Regular internet facing install:

```bash
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.21.0+k3s1 sh -s server \
--cluster-init \
--flannel-backend=wireguard && \
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml && \
cat traefik-config.yaml | envsubst | kubectl apply -f -
```

Internal network install
(Replace all values with the ones that apply for you)

```bash
export INTERNAL_INTERFACE=eth0
```

```bash
export NODE_EXTERNAL_IP=55.55.55.55
```

```bash
export NODE_INTERNAL_IP=192.168.0.1
```

```bash
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.21.0+k3s1 sh -s server \
--cluster-init \
--flannel-backend=wireguard \
--node-external-ip=${NODE_EXTERNAL_IP}  \
--node-ip=${NODE_INTERNAL_IP} \
--advertise-address=${NODE_INTERNAL_IP} \
--flannel-iface=${INTERNAL_INTERFACE} && \
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml && \
cat traefik-config.yaml | envsubst | kubectl apply -f -
```

<details>
<summary>traefik-config.yaml</summary>
```
--8<-- "./manifests/traefik-config.yaml"
```
</details>

** Note ** :
The traefik-config.yaml file could also be copied to `/var/lib/rancher/k3s/server/manifests/traefik-config.yaml` on one of the master nodes. K3S will run these files automatically. But this is optional, and not much help if you are using kubectl from outside the cluster.

```bash
cp traefik-config.yaml /var/lib/rancher/k3s/server/manifests/traefik-config.yaml
```

### Add longhorn (optional)

```bash
kubectl apply -f https://raw.githubusercontent.com/longhorn/longhorn/v1.1.0/deploy/longhorn.yaml
```

### Get the token (Optional)

This token is only needed if you would like to join more masters and workers to the cluster. (There are more secure ways to do this, but its fine for testing)

```bash
cat /var/lib/rancher/k3s/server/node-token
```

## Additional masters (optional)

- Set the environment variables

```bash
export K3S_TOKEN=<Token from master>
```

```bash
export MASTER_IP=<master node IP>
```

- Run the installer

Regular internet facing install:

```bash
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.21.0+k3s1 K3S_TOKEN="${K3S_TOKEN}" sh -s server \
--flannel-backend=wireguard \
--server https://${MASTER_IP}:6443
```

Internal network install
(Replace all values with the ones that apply for you)

```bash
export INTERNAL_INTERFACE=eth0
```

```bash
export NODE_EXTERNAL_IP=55.55.55.55
```

```bash
export NODE_INTERNAL_IP=192.168.0.1
```

```bash
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.21.0+k3s1 K3S_TOKEN="${K3S_TOKEN}" sh -s server \
--flannel-backend=wireguard \
--server https://${MASTER_IP}:6443 \
--node-external-ip=${NODE_EXTERNAL_IP}  \
--node-ip=${NODE_INTERNAL_IP} \
--advertise-address=${NODE_INTERNAL_IP} \
--flannel-iface=${INTERNAL_INTERFACE}
```

## Add worker nodes (optional)

- Set the environment variables

```bash
export K3S_TOKEN=<Token from master>
```

```bash
export MASTER_IP=<master node IP>
```

Regular internet facing install:

```bash
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.21.0+k3s1 K3S_TOKEN="${K3S_TOKEN}" K3S_URL=https://${MASTER_IP}:6443 sh -
```

Internal network install

```bash
export NODE_INTERNAL_IP=192.168.0.1
```

```bash
export INTERNAL_INTERFACE=eth0
```

```bash
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.21.0+k3s1 K3S_TOKEN="${K3S_TOKEN}" \
K3S_URL=https://${MASTER_IP}:6443 INSTALL_K3S_EXEC="--node-ip ${NODE_INTERNAL_IP} --flannel-iface ${INTERNAL_INTERFACE}" \
sh -
```

## Check the cluster

```bash
kubectl get nodes
```

Should output something like this (if you start with one master and add another master):

```bash
NAME   STATUS   ROLES                       AGE     VERSION
m1     Ready    control-plane,etcd,master   3m26s   v1.20.6+k3s1
m2     Ready    control-plane,etcd,master   17s     v1.20.6+k3s1
```

## Done

That's it. You have a single or multi node kubernetes cluster set up.

Continue with the guide to see how to set up some sample applications, basic auth, HTTPS etc.

## Uninstall K3S

If you need to uninstall K3S, you can use these commands from the [k3s docs](https://rancher.com/docs/k3s/latest/en/installation/uninstall/). After that you can repeat the installation process. Sometimes when experimenting, it can also be good to just delete or recreate the VM/VPS you are working on and start from the beginning.

**Server**

```bash
/usr/local/bin/k3s-uninstall.sh
```

**Agent**

```bash
/usr/local/bin/k3s-agent-uninstall.sh
```
