set -e
echo "PUSHING TO GITHUB PAGES"
if [ $(git rev-parse --quiet --verify ${PLATFORM}) > /dev/null ]
then
    echo "Branch ${PLATFORM} already exists, deleting"
    git branch -D ${PLATFORM}
fi

git checkout --orphan ${PLATFORM}
git rm -rf .
git add built/${PLATFORM}
git commit -m "Protobuf and gRPC binaries"
git push ${GIT_HTTPS_REPO_AUTHED} HEAD:${PLATFORM} -f

