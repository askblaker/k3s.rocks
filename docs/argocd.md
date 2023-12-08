## Install ArgoCD
<img src="/docs/img/argoCD.svg" alt="drawing" width="200"/>
[docs](https://argoproj.github.io/argo-cd/getting_started/)  


## Install
### Either with the included manifest
```bash
kubectl create namespace argocd
cat argocd.yaml | envsubst | kubectl apply -n argocd -f -
```
### Or argocd manifest + patched deploy
Or if you prefer the github repo and patching (the patched apply below was the only required change at the time of writing):  
```bash
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml  
kubectl patch deploy argocd-server -n argocd --type json -p '[{"op": "replace", "path": "/spec/template/spec/containers/0/command", "value": ["argocd-server", "--insecure", "--staticassets","/shared/app"]}]'  
```

## ArgoCD UI
Either use port forwarding or create an ingress:

* First we need the tmp one to create a tls (skip if you have a wildcard cert)  
```bash
cat argocd-tmp-ingress.yaml | envsubst | kubectl apply -n argocd -f -
```
* Wait until you see something appear before then deleting it(this actually works but it does not allow for grpc) you should see something appearing at <a href="https://argocd.dog.example.com" target="_blank">https://argocd.dog.example.com</a>

```bash
cat argocd-tmp-ingress.yaml | envsubst | kubectl delete -n argocd -f -
```
* Now create the final ingressroute
```bash
cat argocd-ingressroute.yaml | envsubst | kubectl apply -n argocd -f -
```

Now goto argocd.yourdomain.com, type in admin and 
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo  
```

## ArgoCD CLI
```bash
arkade get argocd
```