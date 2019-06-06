.PHONY: get-creds
get-creds:
	gcloud config set project com-seankhliao
	gcloud config set compute/zone us-central1-a
	gcloud container clusters get-credentials cluster11
	kubectl create clusterrolebinding cluster-admin-binding --clusterrole cluster-admin --user $$(gcloud config get-value account)

.PHONY: deploy-coredns
deploy-coredns:
	./coredns-deploy.sh | kubectl apply -f -
	kubectl scale --replicas=0 deployment/kube-dns-autoscaler --namespace=kube-system
	kubectl scale --replicas=0 deployment/kube-dns --namespace=kube-system

.PHONY: deploy-cert-manager
deploy-cert-manager:
	kubectl create namespace cert-manager
	kubectl label namespace cert-manager certmanager.k8s.io/disable-validation=true
	kubectl apply -f cert-manager-all.yaml

.PHONY: get-acme-certs
get-acme-certs:
	kubectl apply -f cert-manager-issuer.yaml

.PHONY: deploy-traefik
deploy-traefik:
	kubectl apply -f traefik-definition.yaml
	kubectl apply -f traefik.yaml

.PHONY: deploy-readss
deploy-readss:
	kubectl apply -f readss.yaml
