PROJECT=com-seankhliao
REGION=us-central1
ZONE=$(REGION)-a

GCLOUD=gcloud
KUBECTL=kubectl
.PHONY: *
create-cluster:
	$(GCLOUD) config set project $(PROJECT)
	$(GCLOUD) config set compute/region $(REGION)
	$(GCLOUD) config set compute/zone $(ZONE)
	$(GCLOUD) beta container  \
		--project "com-seankhliao" clusters create "cluster22"  \
		--zone "us-central1-a"  \
		--no-enable-basic-auth  \
		--release-channel "rapid"  \
		--machine-type "e2-standard-2"  \
		--image-type "COS"  \
		--disk-type "pd-standard"  \
		--disk-size "40"  \
		--metadata disable-legacy-endpoints=true  \
		--service-account "kluster-compute@com-seankhliao.iam.gserviceaccount.com"  \
		--num-nodes "1"  \
		--no-enable-stackdriver-kubernetes  \
		--enable-ip-alias  \
		--network "projects/com-seankhliao/global/networks/default"  \
		--subnetwork "projects/com-seankhliao/regions/us-central1/subnetworks/default"  \
		--default-max-pods-per-node "110"  \
		--no-enable-master-authorized-networks  \
		--addons HorizontalPodAutoscaling  \
		--enable-autoupgrade  \
		--enable-autorepair  \
		--identity-namespace "com-seankhliao.svc.id.goog"  \
		--enable-shielded-nodes  \
		--shielded-secure-boot
	$(KUBECTL) create clusterrolebinding cluster-admin-binding \
		--clusterrole cluster-admin --user $$($(GCLOUD) config get-value account)

PUBAGE=age14mg08panez45c6lj2cut2l8nqja0k5vm2vxmv5zvc4ufqgptgy2qcjfmuu
PRIVAGE=$HOME/.ssh/age.key

decrypt:
	find . -name 'secret*.age' -exec sh -c 'age -d -i ${PRIVAGE} -o $${0%.age} {}' {} ';'
encrypt:
	find . -name 'secret*.age' -delete
	find . -name 'secret*' -exec age -r ${PUBAGE} -o {}.age {} ';'
