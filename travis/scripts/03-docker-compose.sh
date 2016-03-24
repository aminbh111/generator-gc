#!/bin/bash
set -ev
#-------------------------------------------------------------------------------
# Start docker container
#-------------------------------------------------------------------------------
cd "$HOME"/"$GREENCODE"
if [[ ("$GREENCODE" == 'app-cassandra') && (-a src/main/docker/cassandra.yml) ]]; then
  # travis is not stable with docker... need to start container with privileged
  echo '        privileged: true' >> src/main/docker/cassandra.yml
  docker-compose -f src/main/docker/cassandra.yml build
  docker-compose -f src/main/docker/cassandra.yml up -d
elif [[ ("$GREENCODE" == 'app-mongodb') && (-a src/main/docker/mongodb.yml) ]]; then
  docker-compose -f src/main/docker/mongodb.yml up -d
elif [[ ("$GREENCODE" == 'app-mysql') && (-a src/main/docker/mysql.yml) ]]; then
  docker-compose -f src/main/docker/mysql.yml up -d
elif [[ ("$GREENCODE" == 'app-psql-es-noi18n') ]]; then
  if [ -a src/main/docker/elasticsearch.yml ]; then
    docker-compose -f src/main/docker/elasticsearch.yml up -d
  fi
  if [ -a src/main/docker/postgresql.yml ]; then
    docker-compose -f src/main/docker/postgresql.yml up -d
  fi
elif [[ ("$GREENCODE" == 'app-gateway') || ("$GREENCODE" == 'app-microservice') ]]; then
  if [ -a src/main/docker/greencode-registry.yml ]; then
    docker-compose -f src/main/docker/greencode-registry.yml up -d
    sleep 15
  fi
fi
docker ps -a
