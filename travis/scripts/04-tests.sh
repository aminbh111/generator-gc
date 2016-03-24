#!/bin/bash
set -ev
#--------------------------------------------------
# Launch tests
#--------------------------------------------------
cd "$HOME"/"$GREENCODE"
if [ "$GREENCODE" != "app-gradle" ]; then
  mvn test
else
  ./gradlew test
fi
if [ "$GREENCODE" != "app-microservice" ]; then
  gulp test --no-notification
fi
