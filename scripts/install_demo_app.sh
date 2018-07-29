#!/usr/bin/env bash
set -x

IFACE=`route -n | awk '$1 == "192.168.5.0" {print $8}'`
CIDR=`ip addr show ${IFACE} | awk '$2 ~ "192.168.5" {print $2}'`
IP=${CIDR%%/24}

if [ "${TRAVIS}" == "true" ]; then
IP=${IP:-127.0.0.1}
fi

export VAULT_ADDR=http://${IP}:8200
export VAULT_SKIP_VERIFY=true

# The approle-id could be supplied by the app teams build process - possibly embedded into build image
APPROLEID=`cat /usr/local/bootstrap/.approle-id`

# The wrapped secret-id could be supplied by the platform teams build process
WRAPPED_SECRETID=`cat /usr/local/bootstrap/.wrapped_secret-id`

# Unwrap secret-id from the application
SECRETID=`curl \
    --header "X-Vault-Token: ${WRAPPED_SECRETID}" \
    --request POST \
    ${VAULT_ADDR}/v1/sys/wrapping/unwrap | jq -r .data.secret_id`

echo ${SECRETID}

# Configure payload for approle login
tee login_approle.json <<EOF
{
  "role_id": "${APPROLEID}",
  "secret_id": "${SECRETID}"
}
EOF

# Store the restricted approle vault token
APPROLE_TOKEN=`curl \
    --request POST \
    --data @login_approle.json \
    ${VAULT_ADDR}/v1/auth/approle/login | jq -r .auth.client_token`

echo ${APPROLE_TOKEN}

curl \
    --header "X-Vault-Token: ${APPROLE_TOKEN}" \
    ${VAULT_ADDR}/v1/secret/data/goapp | jq -r .data

SECRETS=`curl \
    --header "X-Vault-Token: ${APPROLE_TOKEN}" \
    ${VAULT_ADDR}/v1/secret/data/goapp | jq -r .data`

DENIED=`curl \
    --header "X-Vault-Token: ${APPROLE_TOKEN}" \
    ${VAULT_ADDR}/v1/secret/data/wrongapp | jq -r .errors`

if [ ${APPROLE_TOKEN} != null ]; then
    echo -e "\nAppRoleID  ${APPROLE_TOKEN}\n
    Current time $(date)\n
    Accessible Secrets /secret/data/goapp \n  ${SECRETS}\n
    Inaccessible Secrets /secret/data/wrongapp  \n ${DENIED}\n"
else
    echo -e "\nTOKEN Expired\n"
fi
