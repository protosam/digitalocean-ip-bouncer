#!/bin/bash
echo $(date) - ip-bouncer is here to automate assigning IPs to a node

if [ "${DIGITALOCEAN_ACCESS_TOKEN}" == "" ]; then
    echo "DIGITALOCEAN_ACCESS_TOKEN must be set for this container to work."
    exit 1
fi

if [ "${DIGITALOCEAN_FLOATING_IP}" == "" ]; then
    echo "DIGITALOCEAN_FLOATING_IP must be set for this container to work."
    exit 1
fi

echo $(date) - auth check...
doctl account get || exit $_

echo $(date) - getting current device assigned to ${DIGITALOCEAN_FLOATING_IP}
ASSIGNED_DEVICE_ID=$(doctl compute floating-ip get "${DIGITALOCEAN_FLOATING_IP}" -o json | jq '.[0].droplet.id')
DEVICE_ID=$(curl -s http://169.254.169.254/metadata/v1/id)

if [ "${ASSIGNED_DEVICE_ID}" == "${DEVICE_ID}" ]; then
    echo $(date) - ${DIGITALOCEAN_FLOATING_IP} already belongs to this node
else
    echo $(date) - reassigning ${DIGITALOCEAN_FLOATING_IP} to this node

    while ! ACTION_ID=$(doctl compute floating-ip-action assign "${DIGITALOCEAN_FLOATING_IP}" "${DEVICE_ID}" -o json | jq '.[0].id'); do
        echo $(date) - WARNING: doctl compute floating-ip-action assign "${DIGITALOCEAN_FLOATING_IP}" "${DEVICE_ID}"
        echo $(date) - reassigning IP failed... retrying in 5s.
        sleep 5s
        echo $(date) - retrying...
    done

    echo $(date) - sleeping 5s
    sleep 5s

    ASSIGNMENT_STATUS=$(doctl compute floating-ip-action get "${DIGITALOCEAN_FLOATING_IP}" "${ACTION_ID}" -o json | jq '.[0].status')
    if [ "${ASSIGNMENT_STATUS}" != "completed" ]; then
        doctl compute floating-ip-action get "${DIGITALOCEAN_FLOATING_IP}" "${ACTION_ID}"
    fi
fi


# sleep forever
echo $(date) - the deed is done, ip-bouncer is going to sleep now
while true; do sleep 60s; done