FROM ubuntu:latest
# we base this on ubuntu

# postfix 

# set env. replace right most column with values specific to your environment
ENV POSTFIX_SMTP_PORT '25'
ENV POSTFIX_TLS_PORT '589'
ENV POSTFIX_LISTEN '0.0.0.0'
ENV POSTFIX_LISTEN6 '::'
ENV POSTFIX_HOSTNAME 'mail'
ENV POSTFIX_DOMAIN 'example.com'
# this is "mynetworks" in the postfix config
ENV POSTFIX_LOCAL_ADDRESSES '10.0.0.0\/24'
# we relay to here
ENV POSTFIX_RELAY_HOST 'nangiala.localdomain'
ENV POSTFIX_ADMINISTRATOR "postmaster@${POSTFIX_DOMAIN}"
# identify the server to any client/other server
ENV POSTFIX_BANNERNAME 'dansta\/docker_postfix_ubuntu'
# postfix runs as this user
ENV POSTFIX_USERNAME 'hamburger'
# this version will be reported to clients/other servers
ENV POSTFIX_VERSION 'latest'
# where do we store mail?
ENV POSTFIX_SPOOL_DIRECTORY '\/var\/spool\/postfix\/'

# create low privilege user
RUN adduser ${POSTFIX_USERNAME} --disabled-password --no-create-home  --shell /bin/nologin

# who made this version
LABEL maintainer=dansta

# check ourselves to know we are alive, i need to think of something smart here.
# telnet will not cut it
#HEALTHCHECK --interval=15s --timeout=3s CMD telnet localhost 25 || exit 1

# update and install packages
RUN apt-get update
RUN apt-get install -y rsyslog
RUN apt-get install -y postfix
RUN apt-get install -y spamass-milter
RUN apt-get install -y postgrey

# add our own config file
ADD files/etc/postfix/main.cf /etc/postfix/main.cf
# replace params
ADD replace_postfixconf.sh /usr/local/bin/replace_postfixconf
ADD key.awk /usr/local/bin/key.awk
ADD value.awk /usr/local/bin/value.awk
RUN chmod u+x /usr/local/bin/replace_postfixconf
RUN /usr/local/bin/replace_postfixconf

# document port usage for docker in case you are going to use it as a service
EXPOSE "${POSTFIX_SMTP_PORT}/tcp"

# remote logging made possible
RUN service rsyslog start

# test nginx for build, run in foreground
STOPSIGNAL SIGTERM
CMD ['postfix']
