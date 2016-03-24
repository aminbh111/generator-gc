#!/bin/bash
set -ev
#-------------------------------------------------------------------------------
# Use greencode-travis-build that contain .m2 and node_modules
#-------------------------------------------------------------------------------
cd "$TRAVIS_BUILD_DIR"/
git clone https://github.com/greencode/greencode-travis-build.git
if [ "$GREENCODE" != 'app-gradle' ]; then
  rm -Rf "$HOME"/.m2/repository/
  mv "$TRAVIS_BUILD_DIR"/greencode-travis-build/repository "$HOME"/.m2/
  ls -al "$HOME"/.m2/
  ls -al "$HOME"/.m2/repository/
fi
if [ "$GREENCODE_NODE_CACHE" == 1 ]; then
  mv "$TRAVIS_BUILD_DIR"/greencode-travis-build/node_modules/ "$GREENCODE_SAMPLES/$GREENCODE"/
  ls -al "$GREENCODE_SAMPLES"/"$GREENCODE"/
fi
