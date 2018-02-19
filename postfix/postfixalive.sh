#!/bin/bash

set -x

while true; do
  if $(postfix status); then
	  sleep 5
  else
	  exit 1
  fi

done
