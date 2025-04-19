# The default target of this Makefile is...
all::

# Import tree-wide shared Makefile behavior and libraries
include ../../shared.mak

-include ../../config.mak
export GIT_TEST_OPTIONS

SHELL_PATH ?= $(SHELL)
TEST_SHELL_PATH ?= $(SHELL_PATH)
TEST_SHELL_PATH_SQ = $(subst ','\'',$(TEST_SHELL_PATH))

all:: test-lint perf

perf: pre-clean
	./run

pre-clean:
	rm -rf test-results test-trace

TPERF = $(sort $(wildcard p[0-9][0-9][0-9][0-9]-*.sh))

$(TPERF):
	@echo "*** $@ ***"; '$(TEST_SHELL_PATH_SQ)' $@ $(GIT_TEST_OPTS)

clean:
	rm -rf build "trash directory".* test-results test-trace

test-lint:
	$(MAKE) -C .. test-lint

.PHONY: all perf $(TPERF) pre-clean clean
