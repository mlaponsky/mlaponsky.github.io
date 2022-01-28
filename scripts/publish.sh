#!/usr/bin/env bash

CURRENT_BRANCH=$(git branch --show-current)
PUBLISH_DIR="$HOME/Projects/mlaponsky.github.io/_posts"
FILE_TO_PUBLISH="${@:$OPTIND:1}"

PUBLISHED_NAME=
PUBLISHING_BRANCH='gh-pages'
verbose='false'
push='true'


print_usage() {
  printf "publish.sh <relative path to file to publish> [-m <new filename>] [-b <branch to publish to>] [-v]"
}

while getopts 'b:m:lv' flag; do
  case "${flag}" in
    b) PUBLISHING_BRANCH="${OPTARG}" ;;
    m) PUBLISHED_NAME="${OPTARG}" ;;
    l) push='false' ;;
    v) verbose='true' ;;
    *) print_usage
       exit 1 ;;
  esac
done

if [ -z "${PUBLISHED_NAME}"]; then
  PUBLISHED_NAME=$(basename "${FILE_TO_PUBLISH}")
  PUBLISHED_NAME=$(echo "${PUBLISHED_NAME}" | tr _ -)
fi

PUBLISHED_NAME="${PUBLISH_DIR}/$(date +'%Y-%m-%d')-${PUBLISHED_NAME}"
mv "${FILE_TO_PUBLISH}" ${PUBLISHED_NAME}

git checkout "${PUBLISHING_BRANCH}"
git add ${PUBLISH_DIR}
git commit -m"${PUBLISHED_NAME}"

if [ "${push}" == 'true' ]; then
  echo "Publishing to ${PUBLISHING_BRANCH}."
  git push origin "${PUBLISHING_BRANCH}"
fi

git checkout "${CURRENT_BRANCH}"

echo "SUCCESS! Published ${PUBLISHED_NAME} to ${PUBLISHING_BRANCH}."
