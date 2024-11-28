#!/bin/bash

# compile the client.properties file
envsubst < /client.properties.template > "${MSK_CONFIG}"

sleep infinity
