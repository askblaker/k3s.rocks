<p align="center">
  <a href="https://k3s.rocks"><img src="/docs/img/logo-green-vectors.svg" alt="k3s.rocks"></a>
</p>

## Why?

<a href="https://www.dockerswarm.rocks/" target="_blank">Dockerswarm.rocks</a> provides great instructions for quickly deploying with **docker swarm**. I thought there should be an equivalent guide for kubernetes. Kubernetes is also very popular and have some great features like <a href="https://helm.sh/" target="_blank">Helm package manager</a> and <a href="https://operatorhub.io/" target="_blank">Operators</a>

<a href="https://kubernetes.io/" target="_blank">Kubernetes</a> however, has a pretty steep learning curve, especially for self hosting.

__Hosted__ cloud alternatives exists, and can be very practical, but they can also be costly and vendor specific. I wanted an alternative to docker swarm, that is (almost) as easy to self host and manage.

<a href="https://docs.docker.com/desktop/kubernetes/" target="_blank">Docker Desktop Kubernetes</a> is great to **develop locally** with kubernetes, in a replicable way.

<a href="https://rancher.com/docs/k3s/latest/en/" target="_blank">K3S Lightweight Kubernetes</a> is great to **deploy** your applications to **production**, in a **distributed cluster**, using the same files used by Docker Desktop Kubernetes locally.

## Disclaimer

<blockquote>

<p>Using docker swarm will probably faster to learn and use more familiar terminology (if you are already using docker compose). Using kubernetes will require you to learn a huge new set of concepts, configurations, files, commands, etc.  I recommend you also check out <a href="https://www.dockerswarm.rocks/" target="_blank">dockerswarm.rocks</a></p>

A lot of commands in this guide are referring to manifest files and CLIs. If you want to run this anywhere close to production you should understand what all of these files and tools does and how they work first.

</blockquote>


## About K3S 

Lightweight Kubernetes. Easy to install, half the memory, all in a binary of less than 100 MB. According to Ranchers its great for: Edge, IoT, CI, Development, ARM ,Embedding K8s and maybe most importantly:

* Situations where a PhD in K8s clusterology is infeasible

You can set up a cluster in about In about an **60 minutes**. (Depending on your setup, you might also want to read about <a href="https://kubernetes.io/docs/tasks/administer-cluster/securing-a-cluster/" target="_blank">Securing kubernetes</a>)

If it doesn't work for you, then you can try a hosted kubernetes solution, or maybe try out docker swarm instead.

## Single server

With K3S you can start with a "cluster" of a single server.

You can set it up, deploy your applications and do everything on a $5 USD/month server.

And then, when the time to grow comes, you can add more servers to the cluster.

With a **small bunch of commands**. Or a script.

And you can create your applications to be ready for massive scale from the beginning, starting from a single small server.

## About **K3S.rocks**

This is not associated with Dockerswarm.rocks, Docker, K3S, Rancher, Kubernetes or any of the tools suggested here.

Its a personal project, gathering ideas, documentation and tools to use existing open source products efficiently together.

## Prerequisites
Really you dont need to know much as you will mostly copy paste commands, but it would not hurt to know a little:

* VPS 
* Linux
* Docker
* kubernetes

## Sources
Some great sources I have used to put this together is:  

[CableSpaghetti](https://github.com/cablespaghetti/k3s-monitoring)  
[rpi4cluster.com](https://rpi4cluster.com/)  
[rancher.com](https://rancher.com/)  
[Traefik blog 1](https://traefik.io/blog/capture-traefik-metrics-for-apps-on-kubernetes-with-prometheus/)   
[Traefik blog 2](https://github.com/traefik-tech-blog/traefik-sre-metrics/)  