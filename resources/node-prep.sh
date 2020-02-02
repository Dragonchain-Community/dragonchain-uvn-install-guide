#!/bin/bash
# First create the dragonchain namespace
echo '{"kind":"Namespace","apiVersion":"v1","metadata":{"name":"dragonchain","labels":{"name":"dragonchain"}}}' | kubectl create -f -
export LC_CTYPE=C  # Needed on MacOS when using tr with /dev/urandom

sudo helm repo add dragonchain https://dragonchain-charts.s3.amazonaws.com && sudo helm repo update
