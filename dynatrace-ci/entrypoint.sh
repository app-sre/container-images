#!/bin/bash

git config --global url."https://${GITLAB_TOKEN}@gitlab.cee.redhat.com".insteadOf "https://gitlab.cee.redhat.com"

exec "$@"
