#!/bin/bash

mkdir -p /root/.ssh
chmod 700 /root/.ssh
if [ -f /user.ssh/id_rsa ]; then
  cp -f /user.ssh/id_rsa /root/.ssh/id_rsa
  chmod 600 /root/.ssh/id_rsa
fi
if [ -f /user.ssh/id_rsa.pub ]; then
  cp -f /user.ssh/id_rsa.pub /root/.ssh/id_rsa.pub
  chmod 644 /root/.ssh/id_rsa.pub
fi