

.PHONY: git-tag
git-tag: ## Tag the current commit with the version number
	@VERSION=$$(cargo metadata --no-deps --format-version 1 | jq -r '.packages[0].version') && \
	echo "Tagging with version from Cargo.toml: $$VERSION" && \
	git tag -a "v$$VERSION" -m "Version v$$VERSION"

.PHONY: git-push-tags
git-push-tags: ## Push commits and tags to the remote
	@git push && git push --tags

.PHONY: help
help: ## Display this help.
	@sh makefile-help.sh $(MAKEFILE_LIST)
