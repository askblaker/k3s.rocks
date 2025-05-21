## First Deploy

### Echo Test

Apply deployment, service and ingress, using the commands below. This will deploy and expose a docker container on a subdomain.

#### Deployment

```bash
--8<-- "./scripts/whoami_deployment.txt"
```

<details>
<summary>whoami-deployment.yaml</summary>
```yaml
--8<-- "./manifests/whoami/whoami-deployment.yaml"
```
</details>

#### Service

```bash
--8<-- "./scripts/whoami_service.txt"
```

<details>
<summary>whoami-service.yaml</summary>
```yaml
--8<-- "./manifests/whoami/whoami-service.yaml"
```
</details>

#### Ingress

```bash
--8<-- "./scripts/whoami_ingress.txt"
```

<details>
<summary>whoami-ingress.yaml</summary>
```yaml
--8<-- "./manifests/whoami/whoami-ingress.yaml"
```
</details>

### Note: Separate or combined yaml

Here we applied deployment, service and ingress separately. Sometimes this makes sense, but we can also combine them into a single file if we prefer. Just separate the sections with a line containing three dashes like this:

```yaml
<Deployment>
---
<Service>
---
<Ingress>
```

### Time to test

Use your browser curl to check <a href="http://dog.example.com/foo" target="_blank">http://example.com/foo</a>. Alternatively <a href="http://your-public-ip/foo" target="_blank">http://your-public-ip/foo</a>

```bash
curl http://your-public-ip/foo
```

```bash
Hostname: whoami-946657448-2xhtv
IP: 127.0.0.1
IP: ::1
IP: 10.42.0.9
IP: fe80::7081:fcff:feaf:af05
RemoteAddr: 10.42.0.8:35284
GET /foo HTTP/1.1
Host: 123.345.123.345
User-Agent: curl/7.81.0
Accept: */*
Accept-Encoding: gzip
X-Forwarded-For: 10.42.0.1
X-Forwarded-Host: 123.345.123.345
X-Forwarded-Port: 80
X-Forwarded-Proto: http
X-Forwarded-Server: traefik-5f77ff7779-s7fh9
X-Real-Ip: 10.42.0.1
```

## Adding HTTPS

The examples below use http->https redirect using a traefik middleware. To utilize it you need to create it first. You can also add/remove it by removing the line ` traefik.ingress.kubernetes.io/router.middlewares: default-redirect-https@kubernetescrd` in any ingress using this middleware like this:

```yaml
metadata:
  name: erpnext-tls-ingress
  annotations:
    spec.ingressClassName: traefik
    cert-manager.io/cluster-issuer: letsencrypt-prod
    traefik.ingress.kubernetes.io/router.middlewares: default-redirect-https@kubernetescrd
```

```bash
--8<-- "./scripts/apply_traefik_redirect_middleware.txt"
```

<details>
<summary>traefik-https-redirect-middleware</summary>
```
--8<-- "./manifests/traefik-https-redirect-middleware.yaml"
```
</details>

To add https support, you need to either use cert-manager and add some tls-info to the ingress, or use a tls terminating load-balancer.

### Cert-manager

You need first to deploy [cert-manager](https-cert-manager-letsencrypt.md).

### Ingress
Then you can apply the ingress.

```bash
--8<-- "./scripts/apply_https_ingress.txt"
```

<details>
<summary>whoami-ingress-tls.yaml</summary>
```yaml
--8<-- "./manifests/whoami/whoami-ingress-tls.yaml"
```
</details>
