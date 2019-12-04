#!/bin/sh

test_description='checkout can handle submodules'

. ./test-lib.sh
. "$TEST_DIRECTORY"/lib-submodule-update.sh



test_expect_success 'setup initialized nested submodules in a branch' '
	test_create_repo sub-nested &&
	test_commit -C sub-nested first &&
	test_create_repo nested &&
	test_commit -C nested first &&
	git -C sub-nested submodule add ../nested &&
	git -C sub-nested add nested &&
	test_tick &&
	git -C sub-nested commit -m "add nested" &&
	test_create_repo project &&
	test_commit -C project first &&
	git -C project checkout -b add-sub &&
	git -C project submodule add ../sub-nested &&
	git -C project add sub-nested &&
	test_tick &&
	git -C project commit -m "add sub" &&
	git -C project submodule update --init --recursive
'

test_expect_failure 'checkout --recurse-submodules between branches with and without initialized nested submodules' '
	git -C project status >expect &&
	git -C project checkout --recurse-submodules master &&
	git -C project checkout --recurse-submodules add-sub &&
	git -C project status >actual &&
	test_cmp expect actual
'

test_done
