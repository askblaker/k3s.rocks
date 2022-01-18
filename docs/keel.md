# Keel

[Keel.sh](https://keel.sh/)

Often you want to control deployments using versions. But sometimes you want to just have the latest version. You can use keel to help automate both.

Just add some annotations to your deployment, and it makes sure to update it if the image has changed. The example below is using a fixed `latest` tag.

Note that it may also require adding an `ImagePullSecret` to access the registry and a `ImagePullPolicy: Always` to the yaml to trigger the image pull.

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
