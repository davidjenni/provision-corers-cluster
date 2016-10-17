#!/bin/sh
DO_REGION=${DO_REGION:="sfo1"}
DO_SIZE=${DO_SIZE:="512mb"}
_CLOUD_CONFIG=${CLOUD_CONFIG:="cloud-config.yaml"}
_CLOUD_CONFIG_GEN=$(basename -s .yaml ${_CLOUD_CONFIG}).gen.yaml

if [ -z ${DO_TOKEN+x} ];
    then echo "Must define env var DO_TOKEN with DO app key, see  https://cloud.digitalocean.com/settings/api/tokens" && exit 1;
fi
if [ -z ${DO_SSH_PUB_KEY_FILE+x} ];
    then echo "Must define env var DO_SSH_PUB_KEY_FILE with SSH public key file" && exit 1;
fi
if [ ! -r ${DO_SSH_PUB_KEY_FILE} ];
    then echo "Cannot find SSH public key file ${DO_SSH_PUB_KEY_FILE}" && exit 1;
fi
_DO_SSH_KEY_ID=$(ssh-keygen -l -E md5 -f ${DO_SSH_PUB_KEY_FILE} | cut -d ' ' -f 2 | cut -d : -f 2-17)
_DO_SSH_PUB_KEY_CONTENT=$(cat ${DO_SSH_PUB_KEY_FILE})

echo Getting etcd discovery token...
_ETCD_DISCOVERY=$(curl -w "\n" "https://discovery.etcd.io/new?size=1")
echo got: ${_ETCD_DISCOVERY}

sed \
    -e "s|{{DO_SSH_PUB_KEY}}|${_DO_SSH_PUB_KEY_CONTENT}|g" \
    -e "s|{{ETCD_DISCOVERY_URL}}|${_ETCD_DISCOVERY}|g" \
      ${_CLOUD_CONFIG} \
    > ${_CLOUD_CONFIG_GEN}

curl -X POST "https://api.digitalocean.com/v2/droplets" \
     --header "Content-Type: application/json" \
     --header "Authorization: Bearer ${DO_TOKEN}" \
     --data '{"region":"'"${DO_REGION}"'",
        "image":"coreos-stable",
        "size":"'"${DO_SIZE}"'",
        "ssh_keys":["'"${_DO_SSH_KEY_ID}"'"],
        "ipv6": true,
        "private_networking": true,
        "name":"coreos1",
        "user_data": "'"$(cat ${_CLOUD_CONFIG_GEN} | sed 's/\"/\\\"/g')"'" }'

