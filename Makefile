# Make targets for Terraform and Ansible
# Use USE_DOCKER=1 to run inside the Docker dev container.

TF_ENV      ?= dev
TF_CLOUD    ?= aws
TF_DIR      := terraform/envs/$(TF_ENV)/$(TF_CLOUD)
ANSIBLE_INV := ansible/inventories/$(TF_ENV)/aws_hosts.ini

define run_tf
	@if [ "$(USE_DOCKER)" = "1" ]; then \
		( cd tools/docker && docker compose run --rm dev terraform -chdir=/workspace/$(TF_DIR) $(1) ); \
	else \
		terraform -chdir=$(TF_DIR) $(1); \
	fi
endef

define run_ansible
	@if [ "$(USE_DOCKER)" = "1" ]; then \
		( cd tools/docker && docker compose run --rm dev ansible-playbook -i /workspace/$(ANSIBLE_INV) /workspace/$(1) ); \
	else \
		ansible-playbook -i $(ANSIBLE_INV) $(1); \
	fi
endef

.PHONY: tf-init tf-validate tf-plan tf-apply ansible-bootstrap ansible-k8s

tf-init:
	$(call run_tf,init)

tf-validate:
	$(call run_tf,validate)

tf-plan:
	$(call run_tf,plan)

tf-apply:
	$(call run_tf,apply)

ansible-bootstrap:
	$(call run_ansible,ansible/playbooks/bootstrap.yml)

ansible-k8s:
	$(call run_ansible,ansible/playbooks/k8s-cluster.yml)
