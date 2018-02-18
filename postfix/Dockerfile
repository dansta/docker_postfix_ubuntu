FROM ubuntu:latest
# We base this on ubuntu

# Postfix 

# Set env. replace right most column with values specific to your environment
ARG POSTFIX_SETGID 
ENV POSTFIX_SETGID ${POSTFIX_SETGID:-postfix}
ARG POSTFIX_SMTP_PORT
ENV POSTFIX_SMTP_PORT ${POSTFIX_SMTP_PORT:-25}
ARG POSTFIX_TLS_PORT
ENV POSTFIX_TLS_PORT ${POSTFIX_TLS_PORT:-589}
ARG POSTFIX_LISTEN
ENV POSTFIX_LISTEN ${POSTFIX_LISTEN:-0.0.0.0}
ARG POSTFIX_LISTEN6
ENV POSTFIX_LISTEN6 ${POSTFIX_LISTEN6:-::}
ARG POSTFIX_HOSTNAME
ENV POSTFIX_HOSTNAME ${POSTFIX_HOSTNAME:-mail}
ARG POSTFIX_DOMAIN
ENV POSTFIX_DOMAIN ${POSTFIX_DOMAIN:-example.com}
# FQDN for debconf
ARG POSTFIX_FQDN
ENV POSTFIX_FQDN ${POSTFIX_FQDN:-${POSTFIX_HOSTNAME}${POSTFIX_DOMAIN}}
# This is "mynetworks" in the postfix config
ARG POSTFIX_LOCAL_ADDRESSES
ENV POSTFIX_LOCAL_ADDRESSES ${POSTFIX_LOCAL_ADDRESSES:-10.0.0.0/24}
# We relay to here
ARG POSTFIX_RELAY_HOST
ENV POSTFIX_RELAY_HOST ${POSTFIX_RELAY_HOST:-nangiala.localdomain}
ARG POSTFIX_ADMINISTRATOR
ENV POSTFIX_ADMINISTRATOR ${POSTFIX_ADMINISTRATOR:-postmaster@${POSTFIX_DOMAIN}}
# Identify the server to any client/other server
ARG POSTFIX_BANNERNAME
ENV POSTFIX_BANNERNAME ${POSTFIX_BANNERNAME:-dansta/docker_postfix_ubuntu}
# Postfix runs as this user
ARG POSTFIX_USERNAME
ENV POSTFIX_USERNAME ${POSTFIX_USERNAME:-hamburger}
# This version will be reported to clients/other servers
ARG POSTFIX_VERSION
ENV POSTFIX_VERSION ${POSTFIX_VERSION:-latest}
# Where do we store mail?
ARG POSTFIX_SPOOL_DIRECTORY
ENV POSTFIX_SPOOL_DIRECTORY ${POSTFIX_SPOOL_DIRECTORY:-/var/spool/postfix}

# Create low privilege user
RUN adduser ${POSTFIX_USERNAME} --disabled-password --no-create-home  --shell /bin/nologin

# Who made this version
LABEL maintainer=dansta

# check ourselves to know we are alive, i need to think of something smart here.
# telnet will not cut it
HEALTHCHECK --interval=15s --timeout=3s CMD postfix status || exit 1

# Install config replacement env
RUN apt-get update && apt-get install -y python3

# Prepare debconf since postfix normally is interactive install
ADD replace.py /usr/local/bin/replace_conf
ADD debconf.sh /usr/local/bin/debconf.sh
RUN chmod u+x /usr/local/bin/replace_conf \
              /usr/local/bin/debconf.sh
RUN chmod u+x /usr/local/bin/debconf.sh
RUN /usr/local/bin/replace_conf /usr/local/bin/debconf.sh POSTFIX
RUN /usr/local/bin/debconf.sh

# Update and install packages
RUN apt-get install -y postfix \
                       spamass-milter \
                       postgrey

# Add our own config file
ADD files/etc/postfix/main.cf /etc/postfix/main.cf
# Replace params
RUN /usr/local/bin/replace_conf /etc/postfix/main.cf POSTFIX

# Remove python3 again
RUN apt-get remove -y python3

# Document port usage for docker in case you are going to use it as a service
EXPOSE "${POSTFIX_SMTP_PORT}/tcp" \
       "${POSTFIX_TLS_PORT}/tcp"

VOLUME /var/spool/ \
       /var/log/postfix \
       /dynamic/ \
       /home/

# Test nginx for build, run in foreground
STOPSIGNAL SIGTERM
CMD ['postfix']
