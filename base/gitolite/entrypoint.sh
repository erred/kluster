#!/bin/sh

set -ex

if [ "${1}" = "ssh" ]; then
    keyfile=/etc/ssh/ssh_host_ed25519_key
    [ -f $keyfile ] || ssh-keygen -q -N '' -f $keyfile -t ed25519

    chown -R git:git ~git
    su - git -c "git config --global init.defaultBranch main"

    if [ ! -f ~git/.ssh/authorized_keys ]; then
        # setup admin user
        f="/tmp/${ADMIN_USER:-admin}.pub"
        echo "${ADMIN_KEY}" > ${f}
        su - git -c "gitolite setup -pk ${f}"
        rm ${f}
    else
        # fixup / ensure everything is ok
        su - git -c "gitolite setup"
    fi
    exec /usr/sbin/sshd -D
elif [ "${1}" = "fcgi" ]; then
    exec /usr/bin/spawn-fcgi -p 1234 -n /usr/bin/fcgiwrap
elif [ "${1}" = "nginx" ]; then
    exec nginx -g 'pid /run/nginx.pid; daemon off;'
else
    echo "needs one of ssh|fcgi|nginx"
    exit 1
fi
