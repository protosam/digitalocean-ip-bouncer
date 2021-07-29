#!/bin/sh
if ! [[ `hostname` =~ ([A-Za-z0-9_-]+)-([0-9]+)$ ]]; then
    echo "container hostnames must contain ordinals"
    exit 1
fi

HOSTNAME_ORDINAL=${BASH_REMATCH[2]}
HOSTNAME_BASE=${BASH_REMATCH[1]}

# appended qualified domain name
if [ "${SERVICE_NAME}" != "" ] && [ "${K8S_NAMESPACE}" != "" ]; then
    AQDN=".${SERVICE_NAME}.${K8S_NAMESPACE}.svc.cluster.local"
fi

python /usr/src/do-ip-bouncer.py \
    --advertise-addr $(hostname)${AQDN}:4000 \
    --seeds ${HOSTNAME_BASE}-0${AQDN}:4000,${HOSTNAME_BASE}-1${AQDN}:4000,${HOSTNAME_BASE}-2${AQDN}:4000 \
    --fence-ip ${DIGITALOCEAN_FLOATING_IP}
