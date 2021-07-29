# Digital Ocean IP Bouncer (v2)
This version of the IP Bouncer is built to run in cloud servers, docker, or Kubernetes.

This is useful for automated recovery when a node goes down.

## On Kubernetes
Installation steps are as follows. Be sure to fill in `DIGITALOCEAN_ACCESS_TOKEN` and `DIGITALOCEAN_FLOATING_IP`.
```text
$ kubectl -n kube-system create secret generic do-ip-bouncer --from-literal=DIGITALOCEAN_ACCESS_TOKEN=${DIGITALOCEAN_ACCESS_TOKEN} --from-literal=DIGITALOCEAN_FLOATING_IP=${DIGITALOCEAN_FLOATING_IP}
$ kubectl -n kube-system apply -f https://raw.githubusercontent.com/protosam/digitalocean-ip-bouncer/master/manifests/statefulset.yaml
$ kubectl -n kube-system rollout status statefulset/digitalocean-ip-bouncer --watch --timeout=10m
```

## Docker
A docker container is available [here](https://github.com/protosam/digitalocean-ip-bouncer/pkgs/container/digitalocean-ip-bouncer).

The script `entry.sh` will launch `do-ip-bouncer.py` and expects at least 3 seed nodes with ordinals starting from 0 - 2, and so  on.

## On Droplets
Just run in on each node that the IP needs to bounce between and it will automatically handle leadership election and IP attachment.
```text
[ALL_NODES_00]$ export DIGITALOCEAN_ACCESS_TOKEN=...

[root@node-01]$ python3 do-ip-bouncer.py --advertise-addr 10.100.0.1:4000 --seeds 10.100.0.1:4000,10.100.0.2:4001,10.100.0.2:4002 --fence-ip 102.103.104.266

[root@node-02]$ python3 do-ip-bouncer.py --advertise-addr 10.100.0.2:4000 --seeds 10.100.0.1:4000,10.100.0.2:4001,10.100.0.2:4002 --fence-ip 102.103.104.266

[root@node-03]$ python3 do-ip-bouncer.py --advertise-addr 10.100.0.3:4000 --seeds 10.100.0.1:4000,10.100.0.2:4001,10.100.0.2:4002 --fence-ip 102.103.104.266
```