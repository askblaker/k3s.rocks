# Technitium dns-server

[Technitium dns-server](https://technitium.com/dns/) is a self hostable open source dns server.

Apply the manifest.

```bash
cat technitium-localstorage.yaml | envsubst | kubectl apply -f -
```

<details>
<summary>technitium-localstorage.yaml</summary>
```
--8<-- "./manifests/technitium-localstorage.yaml"
```
</details>

This example uses a loadbalancer instead of an ingress, so you can simply access the web interface on `http://<server-ip>:5380` and the dns server on port 53. If you want to add a https certificate or basic auth to the web interface you need to use an ingress instead.
