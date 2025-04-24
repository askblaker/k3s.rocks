# HTTPS with Cert-Manager and Letsencrypt

Traefik could do https with letsencrypt on its own. But the added features we get from cert-manager are worth it, so we'll go with that. Most noteworthy is certificate sharing between nodes and pods.

**Note:** Make sure you have set the right environment variables, including email. When using the production ClusterIssuer, you might quickly run into problems if you try and fail too many times, causing letsencrypt to ignore you for a while.

**Note:** Consider setting up a [separate load balancer](external-load-balancer.md) that also handles tls termination.

First, Follow the steps in [first-deploy](first-deploy.md)

- Apply the manifest

```bash
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.17.0/cert-manager.yaml
```

- Wait until all pods are ready

```bash
kubectl get pods --namespace cert-manager
```

```bash
NAME                                       READY   STATUS    RESTARTS   AGE
cert-manager-7dd5854bb4-vtqjx              1/1     Running   0          42s
cert-manager-cainjector-64c949654c-8b7md   1/1     Running   0          42s
cert-manager-webhook-6bdffc7c9d-swgdj      1/1     Running   0          42s
```

### Letsencrypt Production ClusterIssuer

```bash
cat letsencrypt-prod.yaml | envsubst | kubectl apply -f -
```

<details>
<summary>letsencrypt-prod.yaml</summary>
```
--8<-- "./manifests/letsencrypt-prod.yaml"
```
</details>

Add the traefik https redirect middleware

```bash
cat traefik-https-redirect-middleware.yaml | envsubst | kubectl apply -f -
```

<details>
<summary>traefik-https-redirect-middleware.yaml</summary>
```
--8<-- "./manifests/traefik-https-redirect-middleware.yaml"
```
</details>

Add the whoami-tls-ingress.yaml

```bash
cat ./whoami/whoami-ingress-tls.yaml | envsubst | kubectl apply -f -
```

<details>
<summary>whoami-ingress-tls.yaml  </summary>
```
--8<-- "./manifests/whoami/whoami-ingress-tls.yaml"
```
</details>

## Test

point your browser to <a href="https://whoami.example.com" target="_blank">https://whoami.example.com</a> . (It might be a few minutes until certificates are ready). You should get a 200 response, and a simple response of "echo1" showing in the webpage. You should now see your whoami service served with a fresh https certificate.

## Troubleshooting

Se cert-managers official <a href="https://cert-manager.io/docs/faq/acme/" target="_blank">trouble shooting guide</a>

Basically you will do kubectl get/describe following CRDs: issuer, clusterissuer, certificaterequest, order.
