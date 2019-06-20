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

| Name      | Nodes                                                           | Notes                                                              |
| --------- | --------------------------------------------------------------- | ------------------------------------------------------------------ |
| cluster13 | 1x c-1-2G coos-d preempt autoscaled 0-3 <br> 1x f1-micro coos-d |
| cluster12 | 1x c-1-2G coos-d preempt autoscaled 0-3 <br> 1x f1-micro coos-d |
| cluster11 | 1x c-2-2G coos-d preempt                                        | node pools added later can't have service accounts set through gui |
| cluster10 | 1x c-1-2G coos-d preempt acutoscale 0-3 x 2 zones               | autoscaling is weird                                               |
| cluster9  | 1x c-1-2G coos-d preempt autoscaled 0-3 <br> 1x f1-micro coos-d | micro pinned @ 100% cpu                                            |
| cluster8  | 1x c-1-2G coos-d preempt autoscaled 1-4                         | isto + stackdriver has high overhead -> choose more cpu            |
| cluster7  | 1x c-1-2G coos-d                                                |                                                                    |
| cluster6  | 1x c-1-2G ubunut                                                | mostly stable                                                      |
| cluster5  | 1x n1-standard-1 ubuntu                                         | memory heavily underutilized                                       |
| cluster4  | 4x f1-micro ubuntu                                              | bin-packing nodes to death                                         |
| cluster3  | 2x f1-micro ubuntu <br /> 2x f1-micro coos-d                    | alternating dead nodes                                             |
| cluster2  | 1x g1-small ubuntu                                              | 100% cpu                                                           |
| cluster1  | 1x f1-micro ubuntu <br /> 2x f1-micro coos-d                    | alternating dead nodes                                             |
| cluster0  | 1x g1-small ubuntu                                              | never finished creating system pods                                |
