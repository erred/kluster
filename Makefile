.PHONY: get-creds
get-creds:
	gcloud config set project com-seankhliao
	gcloud config set compute/zone us-central1-a
	gcloud container clusters get-credentials cluster10

.PHONY: get-cluster-admin
get-cluster-admin:
	kubectl create clusterrolebinding cluster-admin-binding --clusterrole cluster-admin --user $$(gcloud config get-value account)

.PHONY: limit-resource
limit-resource:
	kubectl scale --replicas=0 deployment/kube-dns-autoscaler --namespace=kube-system
	kubectl scale --replicas=0 deployment/kube-dns --namespace=kube-system
