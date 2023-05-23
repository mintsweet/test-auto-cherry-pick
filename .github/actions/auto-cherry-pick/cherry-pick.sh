#!/bin/bash

set -e

TARGET_BRANCH="release-${LABEL_NAME##*-}"
PR_BRANCH="auto-cherry-pick-$TARGET_BRANCH-$GITHUB_SHA"

echo "==================== Basic Info ===================="
echo "REPOSITORY: $REPOSITORY"
echo "PR Number: $PR_NUMBER"
echo "PR Title: $PR_TITLE"
echo "PR Body: $PR_BODY"
echo "Label: $LABEL_NAME"
echo "GitHub SHA: $GITHUB_SHA"
echo "Author Email: $AUTHOR_EMAIL"
echo "Author Name: $AUTHOR_NAME"
echo "Assignees: $ASSIGNEES"
echo "Target Branch: $TARGET_BRANCH"
echo "PR Branch: $PR_BRANCH"

echo "==================== Git Cherry Pick ===================="
git config --global user.email "$AUTHOR_EMAIL"
git config --global user.name "$AUTHOR_NAME"

git remote update
git fetch --all
git restore .
git checkout -b $PR_BRANCH origin/$TARGET_BRANCH
git cherry-pick -m 1 --strategy=recursive --strategy-option=theirs $GITHUB_SHA || (
	gh pr comment $PR_NUMBER --body "🤖 The current file has a conflict, and the pr cannot be automatically created."
	gh pr edit $PR_NUMBER --add-label "cherry-pick-failed"
	exit 1
)
git push origin $PR_BRANCH

echo "==================== GitHub Auto Create PR ===================="
gh pr create \
	-B $TARGET_BRANCH \
	-H $PR_BRANCH \
	-t "$PR_TITLE (cherry-picked-from #$PR_NUMBER)" \
	-b "this a auto create pr!cherry picked from https://github.com/$REPOSITORY/pull/$PR_NUMBER\n$PR_BODY" \
	-a $ASSIGNEES

gh pr comment $PR_NUMBER --body "🤖 cherry pick finished successfully 🎉!"
gh pr edit $PR_NUMBER --add-label "cherry-pick-completed"
