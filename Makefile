.PHONY: get-creds
get-creds:
	gcloud config set project com-seankhliao
	gcloud config set compute/zone us-west1-a
	gcloud container clusters get-credentials cluster6

.PHONY: init-cluster-rolebind
init-cluster-rolebind:
	kubectl create clusterrolebinding cluster-admin-binding --clusterrole cluster-admin --user $$(gcloud config get-value account)

.PHONY: limit-resource
limit-resource:
	kubectl scale --replicas=0 deployment/kube-dns-autoscaler --namespace=kube-system
	kubectl scale --replicas=1 deployment/kube-dns --namespace=kube-system

.PHONY: deploy-wg
deploy-wg:
	kubectl -n wireguard create secret generic wg0conf --from-file secrets/wg0.conf
	kubectl apply -f ./wireguard.yaml

.PHONY: deploy-traefik-ingress
deploy-traefik-ingress:
	kubectl -n kube-system create configmap traefikconf --from-file configmap/traefik.toml
	kubectl -n kube-system create secret generic cfemail --from-file secrets/cfemail
	kubectl -n kube-system create secret generic cfkey --from-file secrets/cfkey
	kubectl apply -f ./traefik.yaml

.PHONY: secret-cloudflare
secret-cloudflare:
	kubectl -n kube-system create secret generic cloudflare \
		--from-file=cloudflare_email=secrets/cloudflare_email \
		--from-file=cloudflare_key=secrets/cloudflare_key

.PHONY: secret-wireguard
secret-wireguard:
	kubectl create secret generic wireguard\
		--from-file=wg0.conf=secrets/wg0.conf
	
.PHONY: secret-spotify
secret-spotify:
	kubectl create secret generic spotify \
		--from-file=spotify_id=secrets/spotify_id \
		--from-file=spotify_secret=secrets/spotify_secret \
		--from-file=token.json=secrets/spotify-token.json

.PHONY: secret-storage-admin
secret-storage-admin:
	kubectl create secret generic storage-admin \
		--from-file=key.json=secrets/storage-admin-key.json

.PHONY: secret-cloudbuild-viewer
secret-cloudbuild-viewer:
	kubectl create secret generic cloudbuild-viewer \
		--from-file=key.json=secrets/cloudbuild-viewer-key.json

