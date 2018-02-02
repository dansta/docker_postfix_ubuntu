#!/bin/bash

echo debconf debconf/frontend select noninteractive | sudo debconf-set-selections
echo postfix postfix/mailname string ${POSTFIX_FQDN} | sudo debconf-set-selections
echo postfix postfix/main_mailer_type select Internet Site | sudo debconf-set-selections
