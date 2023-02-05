# Erpnext

![erpnext](/img/services-customer.png)
Picture from [erpnext.com](https://erpnext.com/)

To keep in line with the instructions in the erpnext [helm repo](https://github.com/frappe/helm), we will be using helm and namespaces.

Note, make sure [longhorn](/install-setup/#add-longhorn-optional) is installed. It is possible to avvoid it by pre-creating a local-storage pvc and referencing it in `erpnext_values`, but for testing I found it easier to install longhorn and reference it as storageClass instead. This way you will have RWX (the volume cna be mounted as read-write by many nodes) compatible volumes ready for scaling as well.

## Add repo

```bash
helm repo add frappe https://helm.erpnext.com && \
helm repo update
```

## Create namespace

```bash
kubectl create namespace erpnext
```

## Install with helm

```bash
helm install frappe-bench -n erpnext -f erpnext_values.yaml frappe/erpnext
```

<details>
<summary>erpnext_values.yaml</summary>
```
--8<-- "./manifests/erpnext_values.yaml"
```
</details>

### Watch creation

Wait for the containers to be created and settle down

```bash
kubectl get pods -n erpnext --watch
```

You should eventually see something like this

```bash
NAME                                                   READY   STATUS      RESTARTS      AGE
frappe-bench-erpnext-conf-bench-20230204220652-rjtxx   0/1     Completed   0             100s
frappe-bench-erpnext-gunicorn-7989dfb6c8-p7njf         1/1     Running     0             100s
frappe-bench-erpnext-nginx-684d567845-5f845            1/1     Running     0             100s
frappe-bench-erpnext-scheduler-86648bd8d7-h6vrf        1/1     Running     3 (62s ago)   100s
frappe-bench-erpnext-socketio-75bd4648b6-gsbqx         1/1     Running     3 (49s ago)   100s
frappe-bench-erpnext-worker-d-74f5b8fdd4-xg6rp         1/1     Running     3 (55s ago)   100s
frappe-bench-erpnext-worker-l-5dcbbc79d8-8bd8g         1/1     Running     3 (51s ago)   100s
frappe-bench-erpnext-worker-s-54968545c4-2mtkv         1/1     Running     3 (59s ago)   100s
frappe-bench-mariadb-0                                 1/1     Running     0             100s
frappe-bench-redis-cache-master-0                      1/1     Running     0             100s
frappe-bench-redis-queue-master-0                      1/1     Running     0             100s
frappe-bench-redis-socketio-master-0                   1/1     Running     0             100s

```

## Create a new site template

```bash
helm template frappe-bench -n erpnext frappe/erpnext -f erpnext_newsite_values.yaml -s templates/job-create-site.yaml > erpnext_newsite_manifest.yaml
```

The values:

<details>
<summary>erpnext_newsite_values.yaml</summary>
```
--8<-- "./manifests/erpnext_newsite_values.yaml"
```
</details>

Templated manifest:

<details>
<summary>erpnext_newsite_manifest.yaml</summary>
```
--8<-- "./manifests/erpnext_newsite_manifest.yaml"
```
</details>

## Apply the templated manifest

```bash
kubectl apply -n erpnext -f erpnext_newsite_manifest.yaml
```

### View site creation

Get jobs

```bash
kubectl get jobs -n erpnext
```

Result

```bash
NAME                                             COMPLETIONS   DURATION   AGE
frappe-bench-erpnext-conf-bench-20230204220652   1/1           70s        9m25s
frappe-bench-erpnext-new-site-20230204221209     0/1           8s         8s
```

Get logs for the job

```bash
kubectl logs job/frappe-bench-erpnext-new-site-20230204221209 -f -n erpnext
```

Result

```bash
Defaulted container "create-site" out of: create-site, validate-config (init)

Installing frappe...
Updating DocTypes for frappe        : [========================================] 100%
Updating country info               : [========================================] 100%
Updating Dashboard for frappe

Installing erpnext...
Updating DocTypes for erpnext       : [========================================] 100%
Updating customizations for Address
Updating customizations for Contact
Updating Dashboard for erpnext
*** Scheduler is disabled ***

```

## Add ingress

### Without tls

#### Apply ingress

```bash
kubectl apply -f erpnext_notls_ingress.yaml -n erpnext
```

#### Add fake domain to /etc/hosts

Add something like this to the last line (use your server ip and desired fake hostname):

```bash
12.345.67.89 erpnext.k3s
```

or with a commmand:

```bash
sudo -- sh -c "echo '<server ip> erpnext.k3s' >> /etc/hosts"
```

#### Go to site

```bash
http://erpnext.k3s
```

### With tls

#### Note

If you first followed the steps above with a non tls version, you will have a site called erpnext.k3s. Erpnext expects a host header with this domain in it, and this is why we set it in /etc/hosts in the non-tls version.

So when you want a tls version, you have two choices.

_Reinstall_  
Edit the values in the manifests used above to something that is correct, like erpnext.your.domain.com when installing / reinstalling.

OR

_Add Middleware_  
Add a middleware that replaces `erpnext.your.domain.com` with `erpnext.k3s` :

```bash
kubectl apply -f erpnext_replace_host_header_middleware.yaml
```

<details>
<summary>erpnext_replace_host_header_middleware.yaml</summary>
```
--8<-- "./manifests/erpnext_replace_host_header_middleware.yaml"
```
</details>

#### Set environment variables

```bash
export DOMAIN=dog.example.com
```

```bash

export EMAIL=name@example.com
```

#### Apply manifest

```bash
cat ./whoami/whoami-ingress-tls.yaml | envsubst | kubectl apply -f -
```

#### Go to site

```bash
https://erpnext.yourdomain.com
```

### Credentials

username: `Administrator`  
password: `secret`

### Enjoy

![erpnext](/img/erpnext-login.png)
