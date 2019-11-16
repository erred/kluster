PROJECT=com-seankhliao
REGION=us-central1
ZONE=us-central1-a
CLUSTER=cluster17
NODES=2

GCLOUD=gcloud
KUBECTL=kubectl

DEPLOYS := 	kube-system \
			kube-system/coredns \
			monitoring \
			monitoring/grafana \
			monitoring/prometheus \
			ambassador \
			ambassador/ambassador \
			default \
			default/calproxy \
			default/http-server

.PHONY: $(DEPLOYS) create-cluster scale-kube-dns status
$(DEPLOYS):
	$(KUBECTL) apply -k $@

create-cluster:
	$(GCLOUD) config set project $(PROJECT)
	$(GCLOUD) config set compute/zone $(ZONE)
	$(GCLOUD) beta container clusters create "cluster17" \
		--zone "us-central1-a" \
		--no-enable-basic-auth \
		--release-channel "rapid" \
		--machine-type "custom-1-2048" \
		--image-type "COS_CONTAINERD" \
		--disk-type "pd-standard" \
		--disk-size "20" \
		--metadata disable-legacy-endpoints=true \
		--service-account "kluster-compute@com-seankhliao.iam.gserviceaccount.com" \
		--num-nodes "1" \
		--no-enable-cloud-logging \
		--no-enable-cloud-monitoring \
		--enable-ip-alias \
		--network "projects/com-seankhliao/global/networks/default" \
		--subnetwork "projects/com-seankhliao/regions/us-central1/subnetworks/default" \
		--default-max-pods-per-node "110" \
		--addons HorizontalPodAutoscaling \
		--enable-autoupgrade \
		--enable-autorepair
	$(KUBECTL) create clusterrolebinding cluster-admin-binding --clusterrole cluster-admin --user $$($(GCLOUD) config get-value account)

scale-kube-dns: coredns
	$(KUBECTL) scale --replicas=0 deployment/kube-dns-autoscaler --namespace=kube-system
	$(KUBECTL) scale --replicas=0 deployment/kube-dns --namespace=kube-system

status:
	$(KUBECTL) get --all-namespaces po,deploy,sts,ds,svc,mapping,ing
	$(KUBECTL) top node
	$(KUBECTL) top pod --all-namespaces
