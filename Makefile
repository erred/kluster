PROJECT=com-seankhliao
REGION=us-central1
ZONE=us-central1-a
CLUSTER=cluster17
NODES=2
# --image-type "COS_CONTAINERD" \

GCLOUD=gcloud
KUBECTL=kubectl
HELM=helm3

.PHONY: create-cluster
create-cluster:
	$(GCLOUD) config set project $(PROJECT)
	$(GCLOUD) config set compute/zone $(ZONE)
	$(GCLOUD) beta container clusters create $(CLUSTER) \
		--zone $(ZONE) \
		--release-channel "rapid" \
			--machine-type "n1-standard-1" \
			--image-type "UBUNTU_CONTAINERD" \
			--disk-type "pd-standard" \
			--disk-size "30" \
			--metadata disable-legacy-endpoints=true \
			--service-account "kluster-compute@$(PROJECT).iam.gserviceaccount.com" \
			--preemptible \
			--num-nodes "$(NODES)" \
			--enable-autoupgrade \
			--enable-autorepair \
		--enable-ip-alias \
		--network "projects/$(PROJECT)/global/networks/default" \
		--subnetwork "projects/$(PROJECT)/regions/us-central1/subnetworks/default" \
		--default-max-pods-per-node "110" \
		--no-enable-cloud-logging \
		--no-enable-cloud-monitoring \
		--no-enable-basic-auth \
		--addons HorizontalPodAutoscaling \
		--identity-namespace "$(PROJECT).svc.id.goog" \
		--shielded-secure-boot
	$(KUBECTL) create clusterrolebinding cluster-admin-binding --clusterrole cluster-admin --user $$($(GCLOUD) config get-value account)

.PHONY: helm-repo-init
helm-repo-init:
	$(HELM) repo add stable https://kubernetes-charts.storage.googleapis.com
	$(HELM) repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com/

.PHONY: helm-repo-update
helm-repo-update:
	$(HELM) repo update

.PHONY: coredns-install
coredns-install:
	$(HELM) install --generate-name --namespace=kube-system stable/coredns
	$(KUBECTL) scale --replicas=0 deployment/kube-dns-autoscaler --namespace=kube-system
	$(KUBECTL) scale --replicas=0 deployment/kube-dns --namespace=kube-system
