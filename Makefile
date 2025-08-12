.PHONY: deploy-prd-a
deploy-prd-a:
	@./scripts/tag_next_version.sh $(LEVEL) prd-a

.PHONY: deploy-prd-b
deploy-prd-b:
	@./scripts/tag_next_version.sh $(LEVEL) prd-b
