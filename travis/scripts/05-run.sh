#!/bin/bash
set -ev
#-------------------------------------------------------------------------------
# Start the application
#-------------------------------------------------------------------------------
cd "$HOME"/"$GREENCODE"
if [ "$RUN_APP" == 1 ]; then
  if [ "$GREENCODE" != "app-gradle" ]; then
    if [ "$GREENCODE" == 'app-cassandra' ]; then
      chmod -R 777 src/main/resources/config/cql/
      docker cp src/main/resources/config/cql/ traviscassandra-cassandra:/
      docker exec -it traviscassandra-cassandra init
    fi
    mvn package -DskipTests=true -P"$PROFILE"
    mv target/*.war target/app.war
    java -jar target/app.war --spring.profiles.active="$PROFILE" &
  else
    ./gradlew bootRepackage -P"$PROFILE" -x test
    mv build/libs/*.war build/libs/app.war
    java -jar build/libs/app.war --spring.profiles.active="$PROFILE" &
  fi
  sleep 40
  #-------------------------------------------------------------------------------
  # Launch protractor tests
  #-------------------------------------------------------------------------------
  if [ "$PROTRACTOR" == 1 ]; then
    gulp itest --no-notification
  fi
fi
