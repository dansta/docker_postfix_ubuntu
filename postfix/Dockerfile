FROM ubuntu:latest
# We base this on ubuntu

# Postfix 

# Set env. replace right most column with values specific to your environment
ENV POSTFIX_SMTP_PORT '25'
ENV POSTFIX_TLS_PORT '589'
ENV POSTFIX_LISTEN '0.0.0.0'
ENV POSTFIX_LISTEN6 '::'
ENV POSTFIX_HOSTNAME 'mail'
ENV POSTFIX_DOMAIN 'example.com'
# This is "mynetworks" in the postfix config
ENV POSTFIX_LOCAL_ADDRESSES '10.0.0.0/24'
# We relay to here
ENV POSTFIX_RELAY_HOST 'nangiala.localdomain'
ENV POSTFIX_ADMINISTRATOR "postmaster@${POSTFIX_DOMAIN}"
# Identify the server to any client/other server
ENV POSTFIX_BANNERNAME 'dansta/docker_postfix_ubuntu'
# Postfix runs as this user
ENV POSTFIX_USERNAME 'hamburger'
# This version will be reported to clients/other servers
ENV POSTFIX_VERSION 'latest'
# Where do we store mail?
ENV POSTFIX_SPOOL_DIRECTORY '/var/spool/postfix'

# Create low privilege user
RUN adduser ${POSTFIX_USERNAME} --disabled-password --no-create-home  --shell /bin/nologin

# Who made this version
LABEL maintainer=dansta

# check ourselves to know we are alive, i need to think of something smart here.
# telnet will not cut it
#HEALTHCHECK --interval=15s --timeout=3s CMD telnet localhost 25 || exit 1

# Update and install packages
RUN apt-get update
RUN apt-get install -y rsyslog
RUN apt-get install -y postfix
RUN apt-get install -y spamass-milter
RUN apt-get install -y postgrey
RUN apt-get install -y python3

# Add our own config file
ADD files/etc/postfix/main.cf /etc/postfix/main.cf
# Replace params
ADD replace_conf.py /usr/local/bin/replace_conf
RUN chmod u+x /usr/local/bin/replace_conf
RUN /usr/local/bin/replace_conf

# Remove python3 again
RUN apt-get remove -y python3

# Document port usage for docker in case you are going to use it as a service
EXPOSE "${POSTFIX_SMTP_PORT}/tcp"

# Remote logging made possible
RUN service rsyslog start

# Test nginx for build, run in foreground
STOPSIGNAL SIGTERM
CMD ['postfix']
