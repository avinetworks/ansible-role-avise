#!/bin/bash

while true
do
  service avise start
  sleep 1
  docker wait avise
  sleep 1
  docker rm -f avise
  sleep 1
done
