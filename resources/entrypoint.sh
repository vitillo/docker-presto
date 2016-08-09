#!/bin/bash

function addProperty() {
    local path=$1
    local key=$2
    local value=$3
    crudini --set $path "" $key $value
}

function configure() {
    local path=$1
    local envPrefix=$2

    echo "Configuring $1"
    for c in `printenv | perl -sne 'print "$1 " if m/^${envPrefix}_(.+?)=.*/' -- -envPrefix=$envPrefix`; do
        name=`echo ${c} | perl -pe 's/___/-/g; s/__/_/g; s/_/./g' | perl -ne 'print lc'`
        var="${envPrefix}_${c}"
        value=${!var}
        echo " - Setting $name=$value"
        addProperty $path $name "$value"
    done
}

configure /opt/presto/etc/config.properties CONFIG_CONF
configure /opt/presto/etc/log.properties LOG_CONF
configure /opt/presto/etc/node.properties NODE_CONF
configure /opt/presto/etc/catalog/hive.properties HIVE_CONF
dockerize -template /opt/presto/etc/jvm.config.template:/opt/presto/etc/jvm.config

exec $@
