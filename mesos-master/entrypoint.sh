#!/bin/sh

PRINCIPAL=${PRINCIPAL:-root}
ARGS=""

if [ -n "$SECRET" ]; then
  ARGS="$ARGS --authenticate_agents"
  ARGS="$ARGS --credentials=/tmp/credentials"
  touch /tmp/credentials
  chmod 600 /tmp/credentials
  cat <<EOF > /tmp/credentials
{
  "credentials": [
    {
      "principal": "$PRINCIPAL",
      "secret": "$SECRET"
    }
  ]
}
EOF
fi

exec "$@" $ARGS
