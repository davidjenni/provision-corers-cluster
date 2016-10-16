#!/bin/sh
REGION=sfo1
SIZE=512mb
SSH_KEY_ID=52:63:93:08:d1:f2:4d:6d:33:12:71:1c:62:24:e1:26

curl -X POST "https://api.digitalocean.com/v2/droplets" \
     --header "Content-Type: application/json" \
     --header "Authorization: Bearer $DO_TOKEN" \
     --data '{"region":"'"${REGION}"'",
        "image":"coreos-stable",
        "size":"'"$SIZE"'",
        "ssh_keys":["'"$SSH_KEY_ID"'"],
        "ipv6": true,
        "private_networking": true,
        "name":"coreos1",
        "user_data": "'"$(cat cloud-config.yaml | sed 's/\"/\\\"/g')"'" }'

