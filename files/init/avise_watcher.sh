#!/bin/bash



############################################################################
# ------------------------------------------------------------------------
# Copyright 2020 VMware, Inc.  All rights reserved. VMware Confidential
# ------------------------------------------------------------------------
###

while true
do
  service avise start
  sleep 1
  docker wait avise
  sleep 1
  docker rm -f avise
  sleep 1
done
