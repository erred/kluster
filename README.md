# kluster

[![License](https://img.shields.io/github/license/seankhliao/kluster.svg?style=for-the-badge)](LICENSE)

Kubernetes cluster configs

## Cluster N

Tryimg my best to save money on GKE

### Iterations

| Name     | Nodes                                                 | Notes                               |
| -------- | ----------------------------------------------------- | ----------------------------------- |
| cluster6 | 1x custom 1-2048 ubunut                               | mostly stable                       |
| cluster5 | 1x n1-standard-1 ubuntu                               | memory heavily underutilized        |
| cluster4 | 4x f1-micro ubuntu                                    | bin-packing nodes to death          |
| cluster3 | 2x f1-micro ubuntu <br /> 2x f1-micro coos containerd | alternating dead nodes              |
| cluster2 | 1x g1-small ubuntu                                    | 100% cpu                            |
| cluster1 | 1x f1-micro ubuntu <br /> 2x f1-micro coos containerd | alternating dead nodes              |
| cluster0 | 1x g1-small ubuntu                                    | never finished creating system pods |
