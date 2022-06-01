#!/usr/bin/env bash
set -eoux pipefail
IFS=$'\n\t'

# If we are not on a pull request, exit.
[[ -z "${$CIRCLE_PULL_REQUEST}" ]] && exit 0

# Find the base branch this PR is being merged into.
BASE_BRANCH=$(gh pr view --json baseRefName --jq .baseRefName $CIRCLE_PULL_REQUEST)

# Generate the diff.
DIFF=$(composer global exec composer-lock-diff --from ${BASE_BRANCH} --md)

# If there is no diff, exit.
[[ -z "${DIFF}" ]] && exit 0

# Extract Pull Request ID.
PULL_REQUEST_ID=${CIRCLE_PULL_REQUEST##*/}

# Find existing comment, if it exists.
COMMENT_ID=$(gh api --jq '.[] | select(.body | contains("Composer lock diff")) | .id' /repos/${CIRCLE_PROJECT_USERNAME}/${CIRCLE_PROJECT_REPONAME}/issues/${PULL_REQUEST_ID}/comments)

if [[ -z "${COMMENT_ID}" ]]; then
  # Create a new comment.
  gh pr comment ${PULL_REQUEST_ID} --body "Composer lock diff\n\n${DIFF}"
else
  # Update existing comment.
  gh api --method PATCH /repos/${CIRCLE_PROJECT_USERNAME}/${CIRCLE_PROJECT_REPONAME}/issues/comments/${COMMENT_ID} -f body="Composer lock diff\n\n${DIFF}"
fi
