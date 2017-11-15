#!/usr/bin/env bash

# Travis only clones the master branch, so I have to clone everything again to make sure I can switch branches.
mkdir working_dir
git clone https://github.com/randomshinichi/qrllib-deps-builder.git working_dir/qrllib-deps-builder
cd working_dir/qrllib-deps-builder
git remote -v
git branch -a

git checkout --track origin/ubuntu-xenial
cp -r built/* ..

git checkout --track origin/debian-stretch
cp -r built/* ..

git checkout --track origin/gh-pages
rm -rf * .gitignore .travis.yml
cp -r ../ubuntu-xenial ../debian-stretch .

git add .
git commit -m "Protobuf ${PROTOBUF_VER}, gRPC ${GRPCIO_VER}"
git push https://randomshinichi:$GITHUB_TOKEN@github.com/randomshinichi/qrllib-deps-builder.git HEAD:gh-pages -f
