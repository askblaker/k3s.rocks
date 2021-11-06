# Keel
![Keel.sh](https://keel.sh/)

Sometimes(most) you want to control deployments using versions. But sometimes(often) you want to just have the latest version.

Keel makes this process easier, just add some annotations to your deployment, and it makes sure to update it if the image has changed.

It may also require adding an ImagePullSecret and ImagePullPolicy: Always

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-software
  annotations:
    keel.sh/policy: "force"
    keel.sh/trigger: poll
    keel.sh/pollSchedule: "@every 60s"
spec:
  selector:
    matchLabels:
      app: my-software
  replicas: 1
  template:
    metadata:
      labels:
        app: my-software
    spec:
      imagePullSecrets:
      - name: regcred
      containers:
      - name: my-software
        image: custom-registry.com/my-software:latest
        imagePullPolicy: Always
        ports:
        - containerPort: 4578
```
