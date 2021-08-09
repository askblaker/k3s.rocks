# Auto healing demo
Lets see some reasons why we are using kubernetes in the first place. We will use the blogging platform ghost because it is fast an easy to deploy and work with.

#### Deploy ghost
```bash 
cat ghost-ephemeral.yaml | envsubst | kubectl apply -f -
```

#### Make edits
If you now go to <a href="https://ghost.yourdomain.com" target=_blank>https://ghost.yourdomain.com</a> (wait a few seconds for the certificate to be claimed), you should see ghost startpage. Go to <a href="https://ghost.yourdomain.com/ghost" target=_blank>https://ghost.yourdomain.com/ghost</a> and create an account. Make some changes. Go back to the site and see the changes. 

#### Delete the pod
```bash
kubectl get pods

NAME                     READY   STATUS    RESTARTS   AGE
echo1-68949fd997-4g9k4   1/1     Running   0          20m
echo1-68949fd997-tqwwp   1/1     Running   0          20m
ghost-548879c755-bxvrx   1/1     Running   0          6m26s
```
```bash
kubectl delete pod ghost-548879c755-bxvrx
```

Wait for a few seconds an check again.

```bash
kubectl get pods

NAME                     READY   STATUS    RESTARTS   AGE
echo1-68949fd997-4g9k4   1/1     Running   0          22m
echo1-68949fd997-tqwwp   1/1     Running   0          22m
ghost-548879c755-zfffk   1/1     Running   0          14s

```

**Yes!** It just recreates it self. This is one of the great things with kubernetes. Even if this pod was running on a VPS that just died, it would be recreated on a different VPS (as long as you have multiple ones, of course).

**No!** The changes we made are lost! This is a brand new pod, and the data we saved has been deleted. Read the part about persistant storage to see more about how we can deal with this.