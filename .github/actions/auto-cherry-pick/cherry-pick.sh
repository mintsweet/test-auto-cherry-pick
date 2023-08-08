#!/bin/bash

set -e

ORIGIN_PR_LABELS=($(echo "$ORIGIN_PR_LABELS_JSON" | jq -r '.[]'))

echo "::group::Origin Info"
echo "Origin PR Number: $ORIGIN_PR_NUMBER"
echo "Origin PR Title: $ORIGIN_PR_TITLE"
echo "Origin PR Labels: $ORIGIN_PR_LABELS"
echo "GitHub SHA: $GITHUB_SHA"
echo "Author Email: $AUTHOR_EMAIL"
echo "Author Name: $AUTHOR_NAME"
echo "Assignees: $ASSIGNEES"
echo "::endgroup::"

TARGET_LABEL_PREFIX="needs-cherry-pick-"
TARGET_LABEL=""

for label in "${ORIGIN_PR_LABELS[@]}"; do
  if [[ "$label" == "$TARGET_LABEL_PREFIX"* ]]; then
    TARGET_LABEL="$label"
    break
  fi
done

TARGET_BRANCH="release-${TARGET_LABEL##*-}"
AUTO_CREATE_PR_BRANCH="$TARGET_BRANCH-auto-cherry-pick-$PR_NUMBER"
AUTO_CHERRY_PICK_LABEL="bot/auto-cherry-pick"
AUTO_CHERRY_PICK_VERSION_LABEL="bot/auto-cherry-pick-for-$TARGET_BRANCH"
AUTO_CHERRY_PICK_FAILED_LABEL="bot/auto-cherry-pick-failed"
AUTO_CHERRY_PICK_COMPLETED_LABEL="bot/auto-cherry-pick-completed"

echo "::group::Generate Info"
echo "Target Branch: $TARGET_BRANCH"
echo "Auto Create PR Branch: $PR_BRANCH"
echo "Auto Cherry Pick Label: $AUTO_CHERRY_PICK_LABEL"
echo "Auto Cherry Pick Version Label: $AUTO_CHERRY_PICK_VERSION_LABEL"
echo "Auto Cherry Pick Failed Label: $AUTO_CHERRY_PICK_FAILED_LABEL"
echo "Auto Cherry Pick Completed Label: $AUTO_CHERRY_PICK_COMPLETED_LABEL"
echo "::endgroup::"

# echo "::group::Git Cherry Pick"
# git config --global user.email "$AUTHOR_EMAIL"
# git config --global user.name "$AUTHOR_NAME"

# git remote update
# git fetch --all
# git checkout -b $PR_BRANCH origin/$TARGET_BRANCH
# git cherry-pick -m 1 $GITHUB_SHA || (
#   gh pr comment $PR_NUMBER --body "🤖 The current file has a conflict, and the pr cannot be automatically created."
#   gh pr edit $PR_NUMBEr --add-label $AUTO_CHERRY_PICK_FAILED_LABEL
#   exit 1
# )
# git push origin $PR_BRANCH
# echo "::endgroup::"

# echo "::group::GitHub Auto Create PR"
# AUTO_CREATED_PR_LINK=$(gh pr create \
# 	-B $TARGET_BRANCH \
# 	-H $PR_BRANCH \
# 	-t "cherry-pick #$PR_NUMBER $PR_TITLE" \
# 	-b "cherry-pick #$PR_NUMBER $PR_TITLE" \
# 	-a $ASSIGNEES)

# gh pr comment $PR_NUMBER --body "🤖 cherry pick finished successfully 🎉!"
# gh pr edit $PR_NUMBER --add-label $AUTO_CHERRY_PICK_COMPLETED_LABEL || (
# 	gh label create $AUTO_CHERRY_PICK_COMPLETED_LABEL -c "#0E8A16" -d "auto cherry pick completed"
# 	gh pr edit $PR_NUMBER --add-label $AUTO_CHERRY_PICK_COMPLETED_LABEL
# )

# gh pr comment $AUTO_CREATED_PR_LINK --body "🤖 this a auto create pr!cherry picked from #$PR_NUMBER."
# gh pr edit $AUTO_CREATED_PR_LINK --add-label "$AUTO_CHERRY_PICK_LABEL,$AUTO_CHERRY_PICK_VERSION_LABEL" || (
# 	gh label create $AUTO_CHERRY_PICK_VERSION_LABEL -c "#5319E7" -d "auto cherry pick pr for $TARGET_BRANCH"
# 	gh pr edit $AUTO_CREATED_PR_LINK --add-label "$AUTO_CHERRY_PICK_LABEL,$AUTO_CHERRY_PICK_VERSION_LABEL"
# )
# echo "::endgroup::"
