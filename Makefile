.PHONY: deploy-prj-a
deploy-prj-a:
	@./scripts/tag_next_version.sh $(LEVEL) prj-a

.PHONY: deploy-prj-b
deploy-prj-b:
	@./scripts/tag_next_version.sh $(LEVEL) prj-b
