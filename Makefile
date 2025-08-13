.PHONY: deploy-prd-a
deploy-prd-a:
	@./scripts/tag_latest_draft.sh prd-a

.PHONY: deploy-prd-b
deploy-prd-b:
	@./scripts/tag_latest_draft.sh prd-b
