#!/bin/sh

PRINCIPAL=${PRINCIPAL:-root}
ARGS=""

if [ -n "$SECRET" ]; then
  ARGS="$ARGS --mesos_authentication"
  ARGS="$ARGS --mesos_authentication_principal $PRINCIPAL"
  ARGS="$ARGS --mesos_authentication_secret_file /tmp/secret"
  touch /tmp/secret
  chmod 600 /tmp/secret
  printf '%s' "$SECRET" > /tmp/secret
fi

exec "$@" $ARGS
