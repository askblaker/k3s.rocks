# Traefik dashboard

![Traefik Dashboard](./img/traefik-dashboard.webp)

## Expose traefik dashboard

You can use both Kubernetes standard Ingress or the Traefik CRD ingressroute for normal routes. To expose the dashboard you can use a traefik specific ingressroute CRD, or you can set up a service for it.

Create service

```bash
cat traefik-dashboard-service.yaml | envsubst | kubectl apply -f -
```

<details>
<summary>traefik-dashboard-service.yaml</summary>
```
--8<-- "./manifests/traefik-dashboard-service.yaml"
```
</details>

Create ingress

```
cat traefik-dashboard-ingress.yaml | envsubst | kubectl apply -f -
```

<details>
<summary>traefik-dashboard-ingress.yaml</summary>
```
--8<-- "./manifests/traefik-dashboard-ingress.yaml"
```
</details>

Now it should be available at http://traefik.example.com/dashboard/ (note the trailing slash!).

## Old method, using cert-manager

#### Create https certificate for ingressroute

Traefik does not support using cert-manager for tls. So when using ingressroute with https you need to first create a "fake" ingress to get a secret with the desired name. Then you use that secret like below.

> **Wildcard:** Alternatively you could get a wildcard certificate, and just use that. The setup for that is slightly more complicated and might require using a third party nameserver like digitalocean or cloudflare to help with the challenges.

- Create the temporary ingress so cert-manager gets the intial certificate

```bash
cat traefik-dashboard-tmp-ingress.yaml | envsubst | kubectl apply -f -
```

- Wait until you are able to access <a href="https://traefik.example.com" target="_blank">https://traefik.example.com</a> without errors or warnings about certificate.
- Then delete it

```bash
cat traefik-dashboard-tmp-ingress.yaml | envsubst | kubectl delete -f -
```

- Finally create the traefik native ingressroute

```bash
cat traefik-ingressroute-no-auth.yaml | envsubst | kubectl apply -f -
```

# Done

Now you should have the traefik dashboard available on <a href="https://traefik.example.com" target="_blank">https://traefik.yourdomain.com</a>
