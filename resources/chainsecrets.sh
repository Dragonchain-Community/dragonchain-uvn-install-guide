#!/bin/bash
# First create the dragonchain namespace
echo '{"kind":"Namespace","apiVersion":"v1","metadata":{"name":"dragonchain","labels":{"name":"dragonchain"}}}' | kubectl create -f -
export LC_CTYPE=C  # Needed on MacOS when using tr with /dev/urandom
BASE_64_PRIVATE_KEY=$(openssl ecparam -genkey -name secp256k1 | openssl ec -outform DER | tail -c +8 | head -c 32 | xxd -p -c 32 | xxd -r -p | base64)
HMAC_ID=$(tr -dc 'A-Z' < /dev/urandom | fold -w 12 | head -n 1)
HMAC_KEY=$(tr -dc 'A-Za-z0-9' < /dev/urandom | fold -w 43 | head -n 1)
echo "Root HMAC key details: ID: $HMAC_ID | KEY: $HMAC_KEY"
SECRETS_AS_JSON="{\"private-key\":\"$BASE_64_PRIVATE_KEY\",\"hmac-id\":\"$HMAC_ID\",\"hmac-key\":\"$HMAC_KEY\",\"registry-password\":\"\"}"
kubectl create secret generic -n dragonchain "d-INTERNAL_ID-secrets" --from-literal=SecretString="$SECRETS_AS_JSON"
# Note INTERNAL_ID from the secret name should be replaced with the value of .global.environment.INTERNAL_ID from the helm chart values (opensource-config.yaml)
