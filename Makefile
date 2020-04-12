PROJECT=com-seankhliao
REGION=us-central1
ZONE=$(REGION)-a

GCLOUD=gcloud
KUBECTL=kubectl

create-cluster:
	$(GCLOUD) config set project $(PROJECT)
	$(GCLOUD) config set compute/region $(REGION)
	$(GCLOUD) config set compute/zone $(ZONE)
	$(GCLOUD) beta container  \
		--project "com-seankhliao" clusters create "cluster21"  \
		--zone "us-central1-a"  \
		--no-enable-basic-auth  \
		--release-channel "rapid"  \
		--machine-type "e2-standard-2"  \
		--image-type "COS"  \
		--disk-type "pd-standard"  \
		--disk-size "10"  \
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

# .PHONY: decrypt encrypt
# decrypt:
# 	find . -name 'secret*.enc' -exec sh -c 'f={}; openssl enc -d -chacha20 -pbkdf2 -k $$KLUSTER_ENCRYPT -in $$f -out $${f%.enc}' ';'
# encrypt:
# 	find . -name 'secret*.enc' -delete
# 	find . -name 'secret*' -exec sh -c 'f={}; openssl enc -chacha20 -pbkdf2 -k $$KLUSTER_ENCRYPT -in $$f -out $$f.enc' ';'
