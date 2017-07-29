.PHONY: all
all:
	@./elint longlines shellcheck shellcheck-bash

.PHONY: travis
travis:
	@./elint longlines shellcheck shellcheck-bash

.PHONY: longlines
longlines:
	@./elint longlines

.PHONY: shellcheck
shellcheck:
	@./elint shellcheck shellcheck-bash
