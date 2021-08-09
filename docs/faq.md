# F.A.Q.

## Get "http://localhost:8080/version?timeout=32s": dial tcp 127.0.0.1:8080: connect: connection refused
Using helm with k3s can create this error.
It can be solved with
```bash
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
```

## The connection to the server localhost:8080 was refused - did you specify the right host or port?
See previous question

## cat somefile.yaml | envsubst | kubectl apply -f -
The most basic method is to first create the file and then apply it with ```kubectl apply -f somefile.yaml```. But in this example we use the command above to replace variables in the yaml files with the content from the environment variables we set.  

## No such file or directory
Are you sure you are in the manifests directory, (or correctly pick subfolder)