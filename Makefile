.PHONY: 0-setup
0-setup:
	gcloud config set project com-seankhliao
	gcloud config set compute/zone us-central1-a
	gcloud container clusters get-credentials cluster16
	kubectl create clusterrolebinding cluster-admin-binding --clusterrole cluster-admin --user $$(gcloud config get-value account)

.PHONY: 1-coredns
1-coredns:
	kustomize build coredns | kubectl apply -f -
	kubectl scale --replicas=0 deployment/kube-dns-autoscaler --namespace=kube-system
	kubectl scale --replicas=0 deployment/kube-dns --namespace=kube-system

.PHONY: 1-1-certmanager 1-2-certmanager
1-1-certmanager:
	kubectl create namespace cert-manager
	kubectl label namespace cert-manager certmanager.k8s.io/disable-validation=true
1-2-certmanager:
	kustomize build cert-manager | kubectl apply -f -

.PHONY: 2-1-nc
2-1-nc:
	kustomize build nc | kubectl apply -f -
.PHONY: 2-2-traefik
2-2-traefik:
	kustomize build traefik | kubectl apply -f -

.PHONY: calproxy earbug http-server iglogbot rsssubsbot verify-recaptcha
calproxy:
	kustomize build calproxy | kubectl apply -f -
earbug:
	kustomize build earbug | kubectl apply -f -
http-server:
	kustomize build http-server | kubectl apply -f -
iglogbot:
	kustomize build iglogbot | kubectl apply -f -
rsssubsbot:
	kustomize build rsssubsbot | kubectl apply -f -
verify-recaptcha:
	kustomize build verify-recaptcha | kubectl apply -f -
