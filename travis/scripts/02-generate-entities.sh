#!/bin/bash
set -ev

moveEntity() {
  local entity="$1"
  mv "$GREENCODE_SAMPLES"/.greencode/"$entity".json "$HOME"/"$GREENCODE"/.greencode/
}

generateEntity() {
  local entity="$1"
  if [ -a .greencode/"$entity".json ]; then
    yo greencode:entity "$entity" --force --no-insight
    if [ "$GREENCODE" == "app-cassandra" ]; then
      cat src/main/resources/config/cql/*_added_entity_"$entity".cql >> src/main/resources/config/cql/create-tables.cql
    fi
  fi
}

#-------------------------------------------------------------------------------
# Copy entities json
#-------------------------------------------------------------------------------
mkdir -p "$HOME"/"$GREENCODE"/.greencode/
if [ "$GREENCODE" == "app-mongodb" ]; then
  moveEntity MongoBankAccount

  moveEntity FieldTestEntity
  moveEntity FieldTestMapstructEntity
  moveEntity FieldTestServiceClassEntity
  moveEntity FieldTestServiceImplEntity
  moveEntity FieldTestInfiniteScrollEntity
  moveEntity FieldTestPagerEntity
  moveEntity FieldTestPaginationEntity

elif [ "$GREENCODE" == "app-cassandra" ]; then
  moveEntity CassBankAccount

  moveEntity CassTestEntity
  moveEntity CassTestMapstructEntity
  moveEntity CassTestServiceClassEntity
  moveEntity CassTestServiceImplEntity

elif [ "$GREENCODE" == "app-microservice" ]; then
  moveEntity MicroserviceBankAccount
  moveEntity MicroserviceOperation
  moveEntity MicroserviceLabel

  moveEntity FieldTestEntity
  moveEntity FieldTestMapstructEntity
  moveEntity FieldTestServiceClassEntity
  moveEntity FieldTestServiceImplEntity
  moveEntity FieldTestInfiniteScrollEntity
  moveEntity FieldTestPagerEntity
  moveEntity FieldTestPaginationEntity

elif [[ ("$GREENCODE" == "app-mysql") || ("$GREENCODE" == "app-psql-es-noi18n") ]]; then
  moveEntity BankAccount
  moveEntity Label
  moveEntity Operation

  moveEntity FieldTestEntity
  moveEntity FieldTestMapstructEntity
  moveEntity FieldTestServiceClassEntity
  moveEntity FieldTestServiceImplEntity
  moveEntity FieldTestInfiniteScrollEntity
  moveEntity FieldTestPagerEntity
  moveEntity FieldTestPaginationEntity

  moveEntity TestEntity
  moveEntity TestMapstruct
  moveEntity TestServiceClass
  moveEntity TestServiceImpl
  moveEntity TestInfiniteScroll
  moveEntity TestPager
  moveEntity TestPagination
  moveEntity TestManyToOne
  moveEntity TestManyToMany
  moveEntity TestOneToOne

else
  moveEntity BankAccount
  moveEntity Label
  moveEntity Operation

  moveEntity FieldTestEntity
  moveEntity FieldTestMapstructEntity
  moveEntity FieldTestServiceClassEntity
  moveEntity FieldTestServiceImplEntity
  moveEntity FieldTestInfiniteScrollEntity
  moveEntity FieldTestPagerEntity
  moveEntity FieldTestPaginationEntity
fi

ls -l "$HOME"/"$GREENCODE"/.greencode/

#-------------------------------------------------------------------------------
# Generate the entities with yo greencode:entity
#-------------------------------------------------------------------------------
cd "$HOME"/"$GREENCODE"
generateEntity BankAccount
generateEntity MongoBankAccount
generateEntity MicroserviceBankAccount
generateEntity CassBankAccount
generateEntity Label
generateEntity MicroserviceLabel
generateEntity Operation
generateEntity MicroserviceOperation

generateEntity CassTestEntity
generateEntity CassTestMapstructEntity
generateEntity CassTestServiceClassEntity
generateEntity CassTestServiceImplEntity

generateEntity FieldTestEntity
generateEntity FieldTestMapstructEntity
generateEntity FieldTestServiceClassEntity
generateEntity FieldTestServiceImplEntity
generateEntity FieldTestInfiniteScrollEntity
generateEntity FieldTestPagerEntity
generateEntity FieldTestPaginationEntity

generateEntity TestEntity
generateEntity TestMapstruct
generateEntity TestServiceClass
generateEntity TestServiceImpl
generateEntity TestInfiniteScroll
generateEntity TestPager
generateEntity TestPagination
generateEntity TestManyToOne
generateEntity TestManyToMany
generateEntity TestOneToOne

#-------------------------------------------------------------------------------
# Check Javadoc generation
#-------------------------------------------------------------------------------
if [ "$GREENCODE" != "app-gradle" ]; then
  mvn javadoc:javadoc
else
  ./gradlew javadoc
fi
