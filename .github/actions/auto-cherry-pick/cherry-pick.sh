#!/bin/bash

TARGET_BRANCH=${LABEL_NAME##*-}
PR_BRANCH="auto-cherry-pick-$TARGET_BRANCH-$GITHUB_SHA"

echo "REPOSITORY: $REPOSITORY"
echo "PR Number: $PR_NUMBER"
echo "Label: $LABEL_NAME"
echo "GitHub SHA: $GITHUB_SHA"
echo "Author Email: $AUTHOR_EMAIL"
echo "Author Name: $AUTHOR_NAME"
echo "Assignees: $ASSIGNEES"
echo "Target Branch: $TARGET_BRANCH"
echo "PR Branch: $PR_BRANCH"

git config --global user.email "$AUTHOR_EMAIL"
git config --global user.name "$AUTHOR_NAME"

git remote update
git fetch --all
git restore .
git checkout -b $PR_BRANCH origin/$TARGET_BRANCH
git cherry-pick $GITHUB_SHA
git push origin $PR_BRANCH

gh pr create -B $TARGET_BRANCH -H $PR_BRANCH -t "cherry-pick: $PR_NUMBER" -b "this a auto create pr!<br />cherry pick from https://github.com/$REPOSITORY/pull/$PR_NUMBER" -a $ASSIGNEES
gh pr comment $PR_NUMBER --body "🤖 cherry pick finished successfully 🎉!"
