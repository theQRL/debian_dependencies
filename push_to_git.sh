git checkout --orphan ${PLATFORM}
git rm --cached -r .
git add ${BUILD_DIR_PLATFORM}
git commit -m "Protobuf and gRPC binaries"
git push https://randomshinichi:$GITHUB_TOKEN@github.com/randomshinichi/qrllib-deps-builder.git HEAD:${PLATFORM} -f

