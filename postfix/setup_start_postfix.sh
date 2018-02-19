#!/bin/bash

set -x

if ( postfix -v check ); then
  echo Postfix check
  echo Fixing for docker container
  mkdir -p /var/spool/postfix
  mkdir -p /var/lib/postfix
  chown -R postfix:postfix /var/spool/postfix /var/lib/postfix
  chmod -R go-w /usr/lib/postfix
  postconf compatibility_level=2
  postfix -v upgrade-configuration
  if ( postfix -v -c /etc/postfix start ); then
       echo postfix start exited
  fi
fi

