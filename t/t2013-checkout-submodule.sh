#!/bin/sh

test_description='checkout can handle submodules'

. ./test-lib.sh
. "$TEST_DIRECTORY"/lib-submodule-update.sh

# NOTE: this sets up an "old-style" submodule, with an embedded '.git' directory
# might want to change that (call absorbgitdirs)
test_expect_success 'setup' '
	test_create_repo submodule &&
	test_commit -C submodule first &&
	git submodule add ./submodule &&
	test_tick &&
	git commit -m superproject &&
	test_commit -C submodule second &&
	git add submodule &&
	test_tick &&
	git commit -m updated.superproject
'

# TODO: think about moving this test to t7112, and leveraging
# the setup in lib-submodule-update.sh so the setup above does not have to be replicated in t7112.
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

test_expect_success '"checkout HEAD" output honors diff.ignoreSubmodules' '
	test_config diff.ignoreSubmodules dirty &&
	test_when_finished "rm submodule/untracked" &&
	echo x> submodule/untracked &&
	git checkout HEAD >actual 2>&1 &&
	test_must_be_empty actual
'

test_expect_success '"checkout HEAD" output honors submodule.*.ignore from .gitmodules' '
	test_config diff.ignoreSubmodules none &&
	test_when_finished "git config -f .gitmodules --unset submodule.submodule.ignore" &&
	git config -f .gitmodules submodule.submodule.ignore untracked &&
	git checkout HEAD >actual 2>&1 &&
	echo "M	.gitmodules" >expect &&
	test_cmp expect actual
'

test_expect_success '"checkout HEAD" output honors submodule.*.ignore from .git/config' '
	test_when_finished "git config -f .gitmodules --unset submodule.submodule.ignore" &&
	git config -f .gitmodules submodule.submodule.ignore none &&
	test_config submodule.submodule.ignore all &&
	git checkout HEAD >actual 2>&1 &&
	echo "M	.gitmodules" >expect &&
	test_cmp expect actual
'

test_expect_success '"checkout --recurse-submodules <branch>" does not overwrite unstaged changes in submodules' '
	git checkout -b new &&
	test_commit -C submodule third &&
	git add submodule &&
	test_tick &&
	git commit -m third.superproject &&
	echo modif >submodule/third.t &&
# 	git -C submodule add third.t && # different error
# 	TERM=xterm-256color HOME=/Users/Philippe test_pause &&
	# TERM=xterm-256color HOME=/Users/Philippe debug git checkout --recurse-submodules master &&
	test_must_fail git checkout --recurse-submodules master
'
test_expect_success '"checkout --recurse-submodules <branch>" does not overwrite unstaged changes in submodules, even when submodule in <branch> is ahead of HEAD' '
	# Remove settings/modifs from previous tests
	git -C submodule checkout -- third.t &&
	
# 	git clone --recurse-submodules . clone &&
	
	git checkout -b rewind &&
# 	TERM=xterm-256color HOME=/Users/Philippe test_pause &&
	git -C submodule checkout first &&
	# git -C submodule checkout second && # same submodule commit
	git add submodule &&
	test_tick &&
	git commit -m rewind.superproject &&
	echo modif >submodule/first.t &&
# 	git -C submodule add first.t && # changes nothing
	# TERM=xterm-256color HOME=/Users/Philippe test_pause &&
	TERM=xterm-256color HOME=/Users/Philippe debug git checkout --recurse-submodules master &&
	test_must_fail git checkout --recurse-submodules master
'

test_expect_success 'original bug report' '
	
	git init orig &&
	( cd orig &&
	git submodule add https://github.com/Gregy/znapzend-debian submodule &&
	git add . && 
	git commit -m first &&
	git checkout -b newbranch &&
	git -C submodule checkout a3a7b0 &&
	git add . && 
	git commit -m "set new branch to different submodule commit" &&
	echo test > submodule/debian/compat &&
	test_must_fail git checkout --recurse-submodules master 
	)
'

test_expect_success 'second bug report' '
	git clone https://github.com/ltratt/supuner/ &&
	( cd supuner &&
	git submodule add https://github.com/ltratt/extsmail extsmail &&
	git checkout --recurse-submodules -b b &&
	git commit -m "add submodule" . &&
	date >> extsmail/README.md &&
	test_must_fail git checkout --recurse-submodules master
	)
'
# 
# KNOWN_FAILURE_DIRECTORY_SUBMODULE_CONFLICTS=1
# test_submodule_switch_recursing_with_args "checkout"
# 
# test_submodule_forced_switch_recursing_with_args "checkout -f"
# 
# test_submodule_switch "checkout"
# 
# test_submodule_forced_switch "checkout -f"

test_done
