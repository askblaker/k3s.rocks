## First Deploy

### Echo Test

Apply deployment, service and ingress, using the commands below. This will deploy and expose a docker container on a subdomain.

```bash
# Deployment
cat ./whoami/whoami-deployment.yaml | envsubst | kubectl apply -f -
```

<details>
<summary>whoami-deployment.yaml</summary>
```
--8<-- "./manifests/whoami/whoami-deployment.yaml"
```
</details>

```bash
# Service
cat ./whoami/whoami-service.yaml | envsubst | kubectl apply -f -
```

<details>
<summary>whoami-service.yaml</summary>
```
--8<-- "./manifests/whoami/whoami-service.yaml"
```
</details>

```bash
# Ingress
cat ./whoami/whoami-ingress.yaml | envsubst | kubectl apply -f -
```

<details>
<summary>whoami-ingress.yaml</summary>
```
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

## Time to test

Use your browser curl to check <a href="https://the.vps.address/foo" target="_blank">http://the.vps.address/foo</a>

```bash
curl http://the.vps.ip.here/foo
```

```bash
Hostname: whoami-667fc988f6-jn5f8
IP: 127.0.0.1
IP: ::1
IP: 10.42.0.34
IP: dd40::402e:d1ff:bde4:b8db
RemoteAddr: 10.42.0.1:33686
GET /bar HTTP/1.1
Host: 12.344.200.233
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/97.0.4692.99 Safari/537.36
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9
Accept-Encoding: gzip, deflate
Accept-Language: en-US,en;q=0.9
Upgrade-Insecure-Requests: 1
X-Forwarded-For: 11.255.13.126
X-Forwarded-Host: 51.114.111.153
X-Forwarded-Port: 80
X-Forwarded-Proto: http
X-Forwarded-Server: m1
X-Real-Ip: 23.251.11.124
```

## Adding HTTPS

The examples below use http->https redirect using a traefik middleware. To utilize it you need to create it first. You can also remove it by removing the line ` traefik.ingress.kubernetes.io/router.middlewares: default-redirect-https@kubernetescrd`

```bash
cat ./traefik-https-redirect-middleware.yaml | envsubst | kubectl apply -f -
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

```bash
cat ./whoami/whoami-ingress-tls.yaml | envsubst | kubectl apply -f -
```

<details>
<summary>whoami-ingress-tls.yaml</summary>
```
--8<-- "./manifests/whoami/whoami-ingress-tls.yaml"
```
</details>

### Load balancer

```bash
cat ./whoami/whoami-ingress-redirect.yaml | envsubst | kubectl apply -f -
```

<details>
<summary>whoami-ingress-redirect.yaml</summary>
```
--8<-- "./manifests/whoami/whoami-ingress-redirect.yaml"
```
</details>
