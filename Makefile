.PHONY: get-creds
get-creds:
	gcloud config set project com-seankhliao
	gcloud config set compute/zone us-west1-b
	gcloud container clusters get-credentials cluster7

.PHONY: init-cluster-rolebind
init-cluster-rolebind:
	kubectl create clusterrolebinding cluster-admin-binding --clusterrole cluster-admin --user $$(gcloud config get-value account)

.PHONY: limit-resource
limit-resource:
	kubectl scale --replicas=0 deployment/kube-dns-autoscaler --namespace=kube-system
	kubectl scale --replicas=0 deployment/kube-dns --namespace=kube-system
