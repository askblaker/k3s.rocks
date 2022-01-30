# External load balancer

In case you do not wish to expose nodes to internet directly, prefer to perfrom tls termination outside the cluster, or both, you can use a external load balancer to expose your services.

You will point your a-records to this load balancer, and it will forward traffic to your cluster. Place the nodes and the load balancer in a shared private network, and expose only the load balancer to the public internet.

```bash
  ┌────────────────────────────┐
  |     Private  network       |
  │  ┌──────────────────────┐  │
  │  │  Kubernetes Cluster  │  │
  │  │                      │  │
  │  │  ┌──────┐   ┌──────┐ │  │   ┌────────┐
  │  │  │ Node ◄───► Node ◄─┼──┼───► Client │
  │  │  └──────┘   └──────┘ │  │   └────────┘
  │  └──────────────────────┘  │
  └────────────────────────────┘
```

```bash
  ┌────────────────────────────┐
  │      Private  network      │
  │  ┌──────────────────────┐  │
  │  │  Kubernetes Cluster  │  │
  │  │  ┌──────┐   ┌──────┐ │  │
  │  │  │ Node ◄───► Node │ │  │
  │  │  └──▲───┘   └──▲───┘ │  │
  │  └─────┼──────────┼─────┘  │
  │     ┌──┴──────────┴─┐      │
  │     │               │      │   ┌────────┐
  │     │ Load balancer ◄──────┼───► Client │
  │     │               │      │   └────────┘
  │     └───────────────┘      │
  └────────────────────────────┘
```

## Get wildcard certificate

Its popular to set up a load balancer [cert-bot](https://certbot.eff.org/) and a reverse proxy like [nginx](https://www.nginx.com/) or [haproxy](https://www.haproxy.org/) to automatically generate and renew certificates. You could also include health checks in the load balancer, so it would not route traffic to any unhealthy node.

Todo: Add example set up for a VPS with HAPROXY

If you prefer you can also use a load balancer as a service. One example of this is [Hetzner](https://www.hetzner.com/cloud/load-balancer). If you use them to host your domains as well you can set up ssl termination and certificate renewal automatically, but if you dont, you can also paste the certificates manually. You can buy a certificate, or you could generate one with letsencrypt, like this:

```bash
sudo docker run -it --rm --name certbot \
-v "/etc/letsencrypt:/etc/letsencrypt" \
-v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
certbot/certbot certonly \
--manual --preferred-challenges dns
```

Follow the steps, add the dns settings as prompted, and use the generated certificates with the load balancer. You should use the fullchain.pem as a certificate and the private.pem as private key.
