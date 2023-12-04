# Uptime Kuma


[Uptime Kuma](uptime.kuma.pet) A awesome self-hosted monitoring tool.

Apply the manifest.

```bash
cat uptime-kuma.yml | envsubst | kubectl apply -f -
```

<details>
<summary>uptime-kuma.yml</summary>
```
--8<-- "./manifests/uptime-kuma.yml"
```
</details>

This example uses ingress with port 3001 and is redirected to https://uptime.${DOMAIN} it will get its cert from letsencrypt-prod.

This does have a persistent volume of 1gb

More info found here https://github.com/louislam/uptime-kuma