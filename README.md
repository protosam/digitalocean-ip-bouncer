# Digital Ocean IP Bouncer
When this deployment is running in Kubernetes, it will automatically fence an IP when the pod gets rescheduled. 

This helps automatically recover when a node goes down.

Installation steps are as follows. Be sure to fill in `DIGITALOCEAN_ACCESS_TOKEN` and `DIGITALOCEAN_FLOATING_IP`.
```text
$ kubectl -n kube-system create secret generic do-ip-bouncer --from-literal=DIGITALOCEAN_ACCESS_TOKEN=${DIGITALOCEAN_ACCESS_TOKEN} --from-literal=DIGITALOCEAN_FLOATING_IP=${DIGITALOCEAN_FLOATING_IP}
$ kubectl -n kube-system apply -f https://raw.githubusercontent.com/protosam/digitalocean-ip-bouncer/master/deploy.yaml
$ kubectl -n kube-system rollout status deployment/digitalocean-ip-bouncer --watch --timeout=10m
```