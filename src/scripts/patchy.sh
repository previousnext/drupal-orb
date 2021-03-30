#!/usr/bin/env bash
set -eoux pipefail
IFS=$'\n\t'

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
PATCHY_BRANCH=patchy

export COMPOSER_MEMORY_LIMIT=-1

git config --global user.email "admin@previousnext.com.au"
git config --global user.name "Patchy"

git checkout -B $PATCHY_BRANCH
composer2 update --prefer-dist --no-interaction --no-progress --no-suggest
if git diff-files --quiet --ignore-submodules -- composer.lock ; then
  echo "No composer changes"
else
  echo -e "[PATCHY] Updates composer dependencies\n\n" > /tmp/commit-message.txt
  ./bin/composer-lock-diff --md --no-links >> /tmp/commit-message.txt
  git add composer.lock
  git commit -F /tmp/commit-message.txt
  make config-import updb config-export
  git add config-export
  git commit -m "[PATCHY] Updates config" || echo "No config changes"
  git push -f origin $PATCHY_BRANCH
  hub pull-request --no-edit -b master -h $PATCHY_BRANCH || true
fi
# Reset defaults.
git checkout $CURRENT_BRANCH