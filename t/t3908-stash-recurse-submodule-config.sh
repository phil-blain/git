#!/bin/sh

test_description='stash does not touch submodules even if submodule.recurse=true'

. ./test-lib.sh

test_expect_success 'setup' '
	test_create_repo submodule &&
	test_commit -C submodule first first &&
	test_create_repo project &&
	git -C project submodule add ../submodule &&
	git -C project add submodule &&
	test_tick &&
	git -C project commit -m add_sub &&
	test_commit -C project first.super first.super &&
	date >project/submodule/first &&
	date >project/first.super
'

test_expect_success 'stash in superproject does not touch modified submodule files if submodule.recurse=true' '
	git -C project/submodule status >>expect &&
	git -C project -c submodule.recurse=true stash &&
	git -C project/submodule status >>actual &&
	test_cmp expect actual
'

test_done
