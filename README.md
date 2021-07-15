# moved to monorepo: https://github.com/seankhliao/mono

# kluster

Config files for my k8s cluster

[![License](https://img.shields.io/github/license/seankhliao/kluster.svg?style=flat-square&maxAge=31536000)](LICENSE)
![Version](https://img.shields.io/github/v/tag/seankhliao/kluster?sort=semver&style=flat-square)

## secrets

need filter setup, see [blog post](https://seankhliao.com/blog/12020-09-24-gitattributes-age-encrypt/)

## (Old) Clusters

| Name      | Nodes                                                | Notes                                                                 |
| --------- | ---------------------------------------------------- | --------------------------------------------------------------------- |
| cluster28 | hetzner AX51                                         | "medea"                                                               |
| cluster27 | hetzner AX51                                         | "medea"                                                               |
| cluster26 |                                                      | forever stuck in planning                                             |
| cluster25 | hetzner AX41                                         | deployed with kind (kubeadm gives me headaches with pod connectivity) |
| cluster24 | 1x e2-standard-2                                     | misnamed as cluster23                                                 |
| cluster23 | 3x e2-micro cosd / 0x e2-small preempt scaled 0-3    | 1.16/rapid nodes get stuck on ImagePull without error                 |
| cluster22 | 1x e2-standard-2                                     | 10GiB was not enough for kubelet/node                                 |
| cluster21 | 1x e2-standard-2                                     | less monitoring, back to deployments                                  |
| cluster20 | 1x e2-standard-2                                     | statefulsets for data                                                 |
| cluster19 | 1x e2-standard-2                                     | kustomize is rad                                                      |
| cluster18 | 1x c-1-2G cosd                                       |                                                                       |
| cluster17 | 1x c-1-2G cosd                                       | kustomize is okay, i guess                                            |
| cluster16 | 1x c-1-2G cosd preempt scaled 0-2 / 1x f1-micro cosd |                                                                       |
| cluster15 |                                                      | lost to the sands of time                                             |
| cluster13 | 1x c-1-2G cosd preempt scaled 0-3 / 1x f1-micro cosd |                                                                       |
| cluster13 | 1x c-1-2G cosd preempt scaled 0-3 / 1x f1-micro cosd |                                                                       |
| cluster12 | 1x c-1-2G cosd preempt scaled 0-3 / 1x f1-micro cosd |                                                                       |
| cluster11 | 1x c-2-2G cosd preempt                               | node pools added later can't have service accounts set through gui    |
| cluster10 | 1x c-1-2G cosd preempt scaled 0-3 x 2 zones          | autoscaling is weird                                                  |
| cluster9  | 1x c-1-2G cosd preempt scaled 0-3 / 1x f1-micro cosd | micro pinned @ 100% cpu                                               |
| cluster8  | 1x c-1-2G cosd preempt scaled 1-4                    | isto + stackdriver has high overhead -> choose more cpu               |
| cluster7  | 1x c-1-2G cosd                                       |                                                                       |
| cluster6  | 1x c-1-2G ubunut                                     | mostly stable                                                         |
| cluster5  | 1x n1-standard-1 ubuntu                              | memory heavily underutilized                                          |
| cluster4  | 4x f1-micro ubuntu                                   | bin-packing nodes to death                                            |
| cluster3  | 2x f1-micro ubuntu / 2x f1-micro cosd                | alternating dead nodes                                                |
| cluster2  | 1x g1-small ubuntu                                   | 100% cpu                                                              |
| cluster1  | 1x f1-micro ubuntu / 2x f1-micro cosd                | alternating dead nodes                                                |
| cluster0  | 1x g1-small ubuntu                                   | never finished creating system pods                                   |
