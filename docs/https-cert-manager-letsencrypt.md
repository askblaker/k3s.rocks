# HTTPS with Cert-Manager and Letsencrypt
Traefik could do https with letsencrypt on its own. But the added features we get from cert-manager are worth it, so we'll go with that. Most noteworthy is certificate sharing between nodes and pods.

**Note:** Make sure you have set the right environment variables, including email. When using the production ClusterIssuer, you might quickly run into problems if you try and fail too many times, causing letsencrypt to ignore you for a while.

* Apply the manifest
```bash
kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.3.1/cert-manager.yaml
```
* Wait until all pods are ready
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

### Echo Test
Apply deployment, service and ingress, using the commands below. This will deploy and expose a docker container on a subdomain. 

```bash
# Deployment
cat echo-deployment.yaml | envsubst | kubectl apply -f -
```
```bash
# Service
cat echo-service.yaml | envsubst | kubectl apply -f -
```
```bash
# Ingress
cat echo-ingress.yaml | envsubst | kubectl apply -f -
```

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
point your browser to <a href="https://echo.dog.example.com" target="_blank">https://echo.dog.example.com</a> . (It might be a few minutes until certificates are ready). You should get a 200 response, and a simple response of "echo1" showing in the webpage.

## Troubleshooting
Se cert-managers official <a href="https://cert-manager.io/docs/faq/acme/" target="_blank">trouble shooting guide</a>

# Done
You have now up and running HTTPS with letsencrypt using cert-manager.