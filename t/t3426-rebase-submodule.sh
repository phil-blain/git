#!/bin/sh

test_description='rebase can handle submodules'

. ./test-lib.sh
. "$TEST_DIRECTORY"/lib-submodule-update.sh
. "$TEST_DIRECTORY"/lib-rebase.sh

git_rebase () {
	git status -su >expect &&
	ls -1pR * >>expect &&
	git checkout -b ours HEAD &&
	echo x >>file1 &&
	git add file1 &&
	git commit -m add_x &&
	git revert HEAD &&
	git status -su >actual &&
	ls -1pR * >>actual &&
	test_cmp expect actual &&
	may_only_be_test_must_fail "$2" &&
	$2 git rebase "$1"
}

test_submodule_switch_func "git_rebase"

git_rebase_interactive () {
	git status -su >expect &&
	ls -1pR * >>expect &&
	git checkout -b ours HEAD &&
	echo x >>file1 &&
	git add file1 &&
	git commit -m add_x &&
	git revert HEAD &&
	git status -su >actual &&
	ls -1pR * >>actual &&
	test_cmp expect actual &&
	set_fake_editor &&
	echo "fake-editor.sh" >.git/info/exclude &&
	may_only_be_test_must_fail "$2" &&
	$2 git rebase -i "$1"
}

test_submodule_switch_func "git_rebase_interactive"

test_expect_success 'rebase interactive ignores modified submodules' '
	test_when_finished "rm -rf super sub" &&
	git init sub &&
	git -C sub commit --allow-empty -m "Initial commit" &&
	git init super &&
	git -C super submodule add ../sub &&
	git -C super config submodule.sub.ignore dirty &&
	>super/foo &&
	git -C super add foo &&
	git -C super commit -m "Initial commit" &&
	test_commit -C super a &&
	test_commit -C super b &&
	test_commit -C super/sub c &&
	set_fake_editor &&
	git -C super rebase -i HEAD^^
'

test_expect_failure 'rebase across addition of new submodule' '
	git init sub &&
	test_commit -C sub ini &&
	git init super &&
	test_config -C super submodule.recurse true &&
	test_commit -C super ini &&
	git -C super submodule add ../sub &&
	test_commit -C super base &&
	test_commit -C super/sub sub1 &&
	git -C super add sub &&
	test_commit -C super sub1 &&
	test_commit -C super/sub sub2 &&
	git -C super add sub &&
	test_commit -C super sub2 &&
	# test_pause &&
	set_fake_editor &&
	# THIS WORKS (because it firsts checks out "base")
	# git -C super rebase -i --onto base sub1  &&
	# THIS FAILS (modify/delete), says sub2 is left in tree, but it is gone (no .git)
	# test_must_fail git -C super rebase -i --onto ini sub1
	# THIS results in "commits don''t follow merge base" and sub/.git is gone
	FAKE_LINES="edit 1 drop 2 3" git -C super rebase -i --onto ini ini &&
	test_must_fail git -C super rebase --continue &&
	ls super/sub/.git
'

test_done
