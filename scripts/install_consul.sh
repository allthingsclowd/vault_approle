#!/usr/bin/env bash
set -x

IFACE=`route -n | awk '$1 == "192.168.5.0" {print $8;exit}'`
CIDR=`ip addr show ${IFACE} | awk '$2 ~ "192.168.5" {print $2}'`
IP=${CIDR%%/24}

if [ -d /vagrant ]; then
  LOG="/vagrant/logs/consul_${HOSTNAME}.log"
  mkdir -p /vagrant/logs
else
  LOG="consul.log"
fi

if [ "${TRAVIS}" == "true" ]; then
IP=${IP:-127.0.0.1}
fi


PKG="wget unzip"
which ${PKG} &>/dev/null || {
  export DEBIAN_FRONTEND=noninteractive
  apt-get update
  apt-get install -y ${PKG}
}

# check consul binary
[ -f /usr/local/bin/consul ] &>/dev/null || {
    pushd /usr/local/bin
    [ -f consul_1.2.1_linux_amd64.zip ] || {
        sudo wget https://releases.hashicorp.com/consul/1.2.1/consul_1.2.1_linux_amd64.zip
    }
    sudo unzip consul_1.2.1_linux_amd64.zip
    sudo chmod +x consul
    popd
}


AGENT_CONFIG="-config-dir=/etc/consul.d -enable-script-checks=true"
sudo mkdir -p /etc/consul.d
# check for consul hostname or travis => server
if [[ "${HOSTNAME}" =~ "leader" ]]; then
  echo server

  /usr/local/bin/consul members 2>/dev/null || {

      sudo /usr/local/bin/consul agent -server -ui -client=0.0.0.0 -bind=${IP} ${AGENT_CONFIG} -data-dir=/usr/local/consul -bootstrap-expect=1 >${LOG} &
    
    sleep 5

  }
else
  echo agent
  /usr/local/bin/consul members 2>/dev/null || {
    /usr/local/bin/consul agent -client=0.0.0.0 -bind=${IP} ${AGENT_CONFIG} -data-dir=/usr/local/consul -join=${LEADER_IP} >${LOG} &
    sleep 10
  }
fi

echo consul started
