FROM digitalocean/doctl:1-latest
RUN apk add -U jq curl
RUN ln -s /app/doctl /bin/doctl
COPY ./ip-bouncer.sh /usr/src/ip-bouncer.sh
ENTRYPOINT /bin/bash /usr/src/ip-bouncer.sh