.PHONY: deploy-prj-a
deploy-prj-a:
	@./script/push_prd_version_tag.sh $(LEVEL) prj-a

.PHONY: deploy-prj-b
deploy-prj-b:
	@./script/push_prd_version_tag.sh $(LEVEL) prj-b
