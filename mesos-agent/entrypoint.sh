#!/bin/sh

PRINCIPAL=${PRINCIPAL:-root}
ARGS=""

if [ -n "$SECRET" ]; then
  ARGS="$ARGS --credential=/tmp/credential"
  touch /tmp/credential
  chmod 600 /tmp/credential
  cat <<EOF > /tmp/credential
{
  "principal": "$PRINCIPAL",
  "secret": "$SECRET"
}
EOF
fi

exec "$@" $ARGS
