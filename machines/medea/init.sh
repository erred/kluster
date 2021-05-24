#/bin/bash

set -ex

HOST=medea

ssh ${HOST} sh -c "'rm /etc/sysctl.d/*'" || true
ssh ${HOST} sh -c "'rm /etc/ssh/ssh_host_{dsa,rsa,ecdsa}_key*'" || true

FILES=(
    '/root/.ssh/authorized_keys'
    '/etc/sysctl.d/30-ipforward.conf'
    '/etc/modules-load.d/br_netfilter.conf'
    '/etc/kubernetes/kubeadm.yaml'
    '/etc/systemd/network/40-wg0.netdev'
    '/etc/systemd/network/41-wg0.network'
)
for f in ${FILES[@]} ; do
    rsync --progress $(basename ${f}) ${HOST}:${f}
done

ssh ${HOST} pacman -Rns --noconfirm btrfs-progs gptfdisk haveged xfsprogs wget vim net-tools cronie || true
ssh ${HOST} pacman -Syu --noconfirm neovim containerd kubeadm kubelet open-iscsi nfs-utils
ssh ${HOST} systemctl enable containerd kubelet iscsid
ssh ${HOST} sh -c "'rm /etc/kubernetes/kubelet.env'" || true
ssh ${HOST} reboot || true

# ssh ${HOST} kubeadm init --skip-phases=mark-control-plane,addon  --config /etc/kubernetes/kubeadm.yaml
# rsync --progress medea:/etc/kubernetes/admin.conf ~/.config/kube/config
