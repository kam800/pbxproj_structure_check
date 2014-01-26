#!/bin/bash

echo "Testing positive cases..."

PBXPROJ_STRUCTURE_CHECK_BIN="../pbxproj_structure_check.rb"

for positiveCase in positiveCases/*
do
  echo -n "Testing $positiveCase ... " 
  ruby $PBXPROJ_STRUCTURE_CHECK_BIN $positiveCase D44337EF189543F300D1A9D4:D4433808189543F400D1A9D4:D44337E7189543F300D1A9D4:D44337E6189543F300D1A9D4 2> /dev/null
  if [ $? == 0 ]
  then
    echo "OK"
  else
    echo "FAIL"
  fi
done

echo "Testing negative cases..."

for negativeCase in negativeCases/*
do
  echo -n "Testing $negativeCase ... " 
  ruby $PBXPROJ_STRUCTURE_CHECK_BIN $negativeCase D44337EF189543F300D1A9D4:D4433808189543F400D1A9D4 @> /dev/null
  if [ $? == 0 ]
  then
    echo "FAIL"
  else
    echo "OK"
  fi
done
