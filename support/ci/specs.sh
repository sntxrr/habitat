#!/bin/bash

git log HEAD~1..HEAD | grep -q '!!! Temporary Commit !!!'
is_tmp_commit=$?

# When we're on a temporary commit, don't do anything.
if [[ $is_tmp_commit = 0 ]]; then
  exit 0
fi

set -e

run_tests() {
  cd test
  ./test.sh
}

export COMPONENTS=bin
export LIBSODIUM=/home/travis/pkgs/libsodium/1.0.8
export LIBARCHIVE=/home/travis/pkgs/libarchive/3.2.0
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:$LIBARCHIVE/lib/pkgconfig:$LIBSODIUM/lib/pkgconfig"
export LD_LIBRARY_PATH="LD_LIBRARY_PATH:$LIBARCHIVE/lib:$LIBSODIUM/lib"

id
echo "Your effective userid is ${EUID}"
echo "Your home directory is ${HOME}"
env
find /home/travis/pkgs/libarchive/3.2.0

# TODO
# https://docs.travis-ci.com/user/pull-requests
if [ "${TRAVIS_PULL_REQUEST}" = "false" ]; then
    run_tests
else
    run_tests
fi
