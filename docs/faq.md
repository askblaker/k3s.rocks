# F.A.Q.

## Get "http://localhost:8080/version?timeout=32s": dial tcp 127.0.0.1:8080: connect: connection refused

Using helm with k3s can create this error.
It can be solved with

```bash
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
```

## The connection to the server localhost:8080 was refused - did you specify the right host or port?

See previous question

## cat somefile.yaml | envsubst | kubectl apply -f -

The most basic method is to first create the file and then apply it with `kubectl apply -f somefile.yaml`. But in this example we use the command above to replace variables in the yaml files with the content from the environment variables we set.

## No such file or directory

Are you sure you are in the manifests directory, (or correctly pick subfolder)

## Node interal interface

Run the command below to list your interfaces. Look for the one with an address belonging to your private network.

```bash
ip a s | grep -i "UP\|inet"
```

## Reset node

To reset node run uninstall script and reboot.

From [rancher docs](https://rancher.com/docs/k3s/latest/en/installation/uninstall/)
To uninstall K3s from a server node, run:

```bash
/usr/local/bin/k3s-uninstall.sh
```

To uninstall K3s from an agent node, run:

```bash
/usr/local/bin/k3s-agent-uninstall.sh
```

## X-Forwarded-For and X-Real-Ip (proxy protocol)

It can be important to know from what ip address the request originated Analytics and rate limiting are two common cases. This is called proxy protocol.

If we do not enable this in the traefik config we will see errors when we try to send requests. So we have to activate it in the traefik service. If you use a load balancer it is also important to remember to activate this setting in the loadbalancer itself, so you can benefit from it downstream.

We set the deployment.kind to DaemonSet, hostNetwork: true and web.proxyProtocol.insecure for testing. If you are using a load balancer, it is highly recommended to use `proxyProtocol.trustedIPs` instead, set to your load balancer ip. [https://doc.traefik.io/traefik/routing/entrypoints/#proxyprotocol](https://doc.traefik.io/traefik/routing/entrypoints/#proxyprotocol)

The `deamonset` and `hostnetwork: true` settings makes sure there is a traefik pod running on every node, meaning any packet will be forwarded by traefik with the proxy protocol. This is only important if you expect incoming traffic on all nodes and you could consider just having traefik services on certain nodes, and only pointing the load balancer to those nodes.

For a single node deployment with no external load balancer, it should be sufficient to add/uncomment the following to the traefik-config.yml: 
```yml
spec:
  valuesContent: |-
    service:
      spec:
        externalTrafficPolicy: Local
```

<details>
<summary>traefik-config.yaml</summary>
```
--8<-- "./manifests/traefik-config.yaml"
```
</details>



