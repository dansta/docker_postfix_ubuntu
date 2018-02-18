 #!/bin/bash

# Creates service of postfix

# Create image
docker build -t postfix:0.0.1 .

# Create east-west and multicast network
docker network create \
            --opt encrypted \
            --subnet 10.0.0.0/24 \
            --subnet 224.0.0.0/24 \
            --driver overlay \
            postfix

# Create volume for postfix
docker volume create dynamic
docker volume create postfix
docker volume create home

# Create service
docker service create \
            --mode global \
            --update-delay 60s \
            --update-parallelism 1 \
            --dns 127.0.0.1 \
            --network postfix \
            --mount source=postfix,target=/var/log/postfix \
            --mount source=postfix,target=/var/spool/ \
            --mount source=dynamic,target=/dynamic/ \
            --mount source=home,target=/home/ \
            --name "postfix" \
            --publish published=25,target=25,protocol=tcp \
            postfix:0.0.1
