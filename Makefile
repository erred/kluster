PUBAGE=age14mg08panez45c6lj2cut2l8nqja0k5vm2vxmv5zvc4ufqgptgy2qcjfmuu
PRIVAGE=${HOME}/.ssh/age.key

FILES := \
	_terraform/terraform.tfstate \
	_terraform/terraform.tfstate.backup \
	cert-manager/secret.yaml \
	ghdefaults/secret.yaml \
	pomerium/secret.yaml \
	weechat/ssl/relay.pem \
	weechat/ssl/freenode.pem \
	weechat/ssl/relay.conf


.PHONY: encrypt decrypt ${FILES}
decrypt:
	find . -name 'secret*.age' -exec sh -c 'age -d -i ${PRIVAGE} -o $${0%.age} {}' {} ';'

encrypt: ${FILES}
${FILES}:
	@rm $@.age || true
	age -r ${PUBAGE} -o $@.age $@
