git checkout --orphan ${PLATFORM}
git rm --cached -r .
git add built/${PLATFORM}
git commit -m "Protobuf and gRPC binaries"
git push https://randomshinichi:$GITHUB_TOKEN@github.com/randomshinichi/qrllib-deps-builder.git HEAD:${PLATFORM} -f

