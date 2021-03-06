 #!/bin/bash -x

# Creates service of postfix

# Create image
docker build -t postfix:0.0.1 .

# Create volume for postfix
docker volume create dynamic
docker volume create postfix
docker volume create home
docker volume create certificates

# Create service
docker service create \
            --mode global \
            --update-delay 60s \
            --update-parallelism 1 \
            --dns 8.8.8.8 \
            --dns 9.9.9.9 \
            --mount source=postfix,target=/var/log/postfix \
            --mount source=postfix,target=/var/spool/ \
            --mount source=dynamic,target=/dynamic/ \
            --mount source=home,target=/home/ \
            --mount source=certificates,target=/certificates/ \
            --name "postfix" \
            --publish published=25,target=25,protocol=tcp \
            postfix:0.0.1
