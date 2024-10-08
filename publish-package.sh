#!/bin/sh

set -e

CURRENT_BRANCH=`git name-rev --name-only HEAD`

if [ $CURRENT_BRANCH != 'master' ] ; then
  echo "Build not on master. Skipped pushing to chosen-package"
  exit 0
fi

CHOSEN_VERSION=`git tag --sort=v:refname | tail -1`
GITHUB_URL=https://github.com/namely/chosen-js.git

git clone $GITHUB_URL
rm -rf chosen-js
cp README.md public/*.json public/*.png public/*.js public/*.css public/LICENSE* chosen-js/
cp package-travis.yml chosen-js/.travis.yml
cd chosen-js

git config user.email "admin@namely.com"
git config user.name "chosen-package"

LATEST_VERSION=`git tag --sort=v:refname | tail -1`

git remote set-url origin $GITHUB_URL

git add -A
git commit -m "Chosen build to chosen-package"

if [ "$LATEST_VERSION" = "$CHOSEN_VERSION" ] ; then
  echo "No Chosen version change. Skipped tagging"
else
  echo "Chosen version changed. Tagging version ${CHOSEN_VERSION}\n"
  git tag -a "${CHOSEN_VERSION}" -m "Version ${CHOSEN_VERSION}"
fi

git push origin master
git push origin --tags

echo "Chosen built and pushed to harvesthq/chosen-package"
