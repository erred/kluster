KUBECTL=kubectl.1.15


.PHONY: 0-setup
0-setup:
	gcloud config set project com-seankhliao
	gcloud config set compute/zone us-central1-a
	gcloud container clusters get-credentials cluster16
	$(KUBECTL) create clusterrolebinding cluster-admin-binding --clusterrole cluster-admin --user $$(gcloud config get-value account)

.PHONY: 1-coredns
1-coredns:
	./coredns/deploy.sh | $(KUBECTL) apply -f -
	$(KUBECTL) scale --replicas=0 deployment/kube-dns-autoscaler --namespace=kube-system
	$(KUBECTL) scale --replicas=0 deployment/kube-dns --namespace=kube-system

.PHONY: 2-traefik
2-traefik:
	$(KUBECTL) kustomize traefik | $(KUBECTL) apply -f -

.PHONY: calproxy earbug http-server iglogbot rsssubsbot verify-recaptcha
# calproxy:
# 	kustomize build calproxy | kubectl apply -f -
# earbug:
# 	kustomize build earbug | kubectl apply -f -
http-server:
	$(KUBECTL) kustomize http-server | $(KUBECTL) apply -f -
iglogbot:
	$(KUBECTL) kustomize iglogbot | $(KUBECTL) apply -f -
rsssubsbot:
	$(KUBECTL) kustomize rsssubsbot | $(KUBECTL) apply -f -
verify-recaptcha:
	$(KUBECTL) kustomize verify-recaptcha | $(KUBECTL) apply -f -
