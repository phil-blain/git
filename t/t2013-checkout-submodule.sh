#!/bin/sh

test_description='checkout can handle submodules'

. ./test-lib.sh
. "$TEST_DIRECTORY"/lib-submodule-update.sh

test_expect_success 'setup' '
	mkdir submodule &&
	(cd submodule &&
	 git init &&
	 test_commit first) &&
	git add submodule &&
	test_tick &&
	git commit -m superproject &&
	(cd submodule &&
	 test_commit second) &&
	git add submodule &&
	test_tick &&
	git commit -m updated.superproject
'

test_expect_success '"reset <submodule>" updates the index' '
	git update-index --refresh &&
	git diff-files --quiet &&
	git diff-index --quiet --cached HEAD &&
	git reset HEAD^ submodule &&
	test_must_fail git diff-files --quiet &&
	git reset submodule &&
	git diff-files --quiet
'

test_expect_success '"checkout <submodule>" updates the index only' '
	git update-index --refresh &&
	git diff-files --quiet &&
	git diff-index --quiet --cached HEAD &&
	git checkout HEAD^ submodule &&
	test_must_fail git diff-files --quiet &&
	git checkout HEAD submodule &&
	git diff-files --quiet
'

test_expect_success '"checkout <submodule>" honors diff.ignoreSubmodules' '
	git config diff.ignoreSubmodules dirty &&
	echo x> submodule/untracked &&
	git checkout HEAD >actual 2>&1 &&
	test_must_be_empty actual
'

test_expect_success '"checkout <submodule>" honors submodule.*.ignore from .gitmodules' '
	git config diff.ignoreSubmodules none &&
	git config -f .gitmodules submodule.submodule.path submodule &&
	git config -f .gitmodules submodule.submodule.ignore untracked &&
	git checkout HEAD >actual 2>&1 &&
	test_must_be_empty actual
'

test_expect_success '"checkout <submodule>" honors submodule.*.ignore from .git/config' '
	git config -f .gitmodules submodule.submodule.ignore none &&
	git config submodule.submodule.path submodule &&
	git config submodule.submodule.ignore all &&
	git checkout HEAD >actual 2>&1 &&
	test_must_be_empty actual
'

KNOWN_FAILURE_DIRECTORY_SUBMODULE_CONFLICTS=1
test_submodule_switch_recursing_with_args "checkout"

test_submodule_forced_switch_recursing_with_args "checkout -f"

test_submodule_switch "checkout"

test_submodule_forced_switch "checkout -f"

test_expect_success 'checkout --recurse-submodules fails cleanly if submodules are missing - setup' '
	test_config_global protocol.file.allow always &&
	git init project &&
	test_commit -C project first &&
	git init sub &&
	test_commit -C sub sub-first &&
	git -C project submodule add ../sub sub &&
	git -C project commit -m "add sub" &&
	git -C project tag added &&
	git -C project rm sub &&
	git -C project commit -m "remove sub" &&
	git -C project tag removed &&
	test_commit -C project replace-w-file sub content replaced-w-file &&
	git clone --recurse-submodules -b removed project clone
'

test_checkout_recurse_from_tag () {
	local tag="$1" &&
	git -C clone checkout -q "$tag" &&
	test_must_fail git -C clone checkout --recurse-submodules added 2>actual &&
	echo "fatal: not a git repository: ../.git/modules/sub" >not-expected &&
	echo "fatal: could not reset submodule index" >>not-expected &&
	! test_cmp not-expected actual &&
	echo "The following submodules are not yet cloned" >expected &&
	test_path_is_missing clone/sub/ &&
	test_path_is_missing clone/.git/modules/sub/
}

test_expect_success 'checkout --recurse-submodules fails cleanly if submodules are missing - none to sub' '
	test_checkout_recurse_from_tag removed
'
test_expect_success 'checkout --recurse-submodules fails cleanly if submodules are missing - file to sub' '
	test_checkout_recurse_from_tag replaced-w-file
'

test_done
