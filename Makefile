.PHONY: setup
setup:
	gcloud config set project com-seankhliao
	gcloud config set compute/zone us-central1-a
	gcloud container clusters get-credentials cluster13
	kubectl create clusterrolebinding cluster-admin-binding --clusterrole cluster-admin --user $$(gcloud config get-value account)

.PHONY: coredns
coredns:
	kustomize build coredns | kubectl apply -f -
	kubectl scale --replicas=0 deployment/kube-dns-autoscaler --namespace=kube-system
	kubectl scale --replicas=0 deployment/kube-dns --namespace=kube-system

.PHONY: certmanager
certmanager:
	kubectl create namespace cert-manager
	kubectl label namespace cert-manager certmanager.k8s.io/disable-validation=true
	kustomize build cert-manager | kubectl apply -f -

.PHONY: traefik
traefik:
	kustomize build traefik | kubectl apply -f -

.PHONY: authed earbug http-server iglog readss verify-recaptcha
authed:
	kustomize build authed | kubectl apply -f -
earbug:
	kustomize build earbug | kubectl apply -f -
http-server:
	kustomize build http-server | kubectl apply -f -
iglog:
	kustomize build iglog | kubectl apply -f -
readss:
	kustomize build readss| kubectl apply -f -
verify-recaptcha:
	kustomize build verify-recaptcha | kubectl apply -f -
