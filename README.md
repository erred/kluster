# kluster

Config files for my k8s cluster on GKE

[![License](https://img.shields.io/github/license/seankhliao/kluster.svg?style=for-the-badge&maxAge=31536000)](LICENSE)

## About

kubectl conf files for things I run

necessary secrets in [private repo](https://github.com/seankhliao/kluster-secrets)

#### Customizations

1. No Load Balancer in front (save costs)

   - expose traefik with hostPort
   - configure DNS with [cf-dns-update](https://github.com/seankhliao/cf-dns-update)

2. coreDNS instead of standard kube-dns
   - kube-dns requests a lot of CPU

## Usage

#### Prerequisites

1. Be me
2. Have the appropriate secrets deployed

#### Usage

1. edit [Makefile](Makefile) to point to right cluster
2. run `make` targets
3. deploy secrets
4. `kubectl apply -f deploys`

## Old Clusters

| Name         | Nodes                                                 | Notes                               |
| ------------ | ----------------------------------------------------- | ----------------------------------- |
| **cluster7** | 1x custom 1-2048 coos containerd                      |                                     |
| cluster6     | 1x custom 1-2048 ubunut                               | mostly stable                       |
| cluster5     | 1x n1-standard-1 ubuntu                               | memory heavily underutilized        |
| cluster4     | 4x f1-micro ubuntu                                    | bin-packing nodes to death          |
| cluster3     | 2x f1-micro ubuntu <br /> 2x f1-micro coos containerd | alternating dead nodes              |
| cluster2     | 1x g1-small ubuntu                                    | 100% cpu                            |
| cluster1     | 1x f1-micro ubuntu <br /> 2x f1-micro coos containerd | alternating dead nodes              |
| cluster0     | 1x g1-small ubuntu                                    | never finished creating system pods |
