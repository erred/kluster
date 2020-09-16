PUBAGE=age14mg08panez45c6lj2cut2l8nqja0k5vm2vxmv5zvc4ufqgptgy2qcjfmuu
PRIVAGE=${HOME}/.ssh/age.key

create:
	terraform init
	terraform apply -target google_container_node_pool.stable -target google_container_node_pool.preempt
	terraform apply

decrypt:
	find . -name 'secret*.age' -exec sh -c 'age -d -i ${PRIVAGE} -o $${0%.age} {}' {} ';'
encrypt:
	find . -name 'secret*.age' -delete
	find . -name 'secret*' -exec age -r ${PUBAGE} -o {}.age {} ';'
