FROM ubuntu:latest
# we base this on ubuntu

# postfix 

# set env. replace right most column with values specific to your environment
ENV POSTFIX_LISTEN 25
ENV POSTFIX_VAR1 a
ENV POSTFIX_VAR2 b

LABEL maintainer=dansta

# check ourselves to know we are alive
HEALTHCHECK --interval=15s --timeout=3s CMD ncat localhost 25 || exit 1

# update and install packages
RUN apt-get update
RUN apt-get install -y netcat
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
EXPOSE ${POSTFIX_LISTEN}/tcp

# remote logging made possible
RUN service rsyslog start

# test nginx for build, run in foreground
STOPSIGNAL SIGTERM
CMD ["postfix", "-g", "daemon off;"]
