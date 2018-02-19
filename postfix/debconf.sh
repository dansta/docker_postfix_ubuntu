#!/bin/bash

echo debconf debconf/frontend select noninteractive | debconf-set-selections
echo postfix postfix/mailname string POSTFIX_FQDN | debconf-set-selections
echo postfix postfix/main_mailer_type select Internet Site | debconf-set-selections
