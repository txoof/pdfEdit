#!/bin/bash
myname='com.txoof.'`basename $0`
if [ $# -lt 1 ]
then
  echo supply at least one file name to process. exiting.
  exit 0
fi

tmpdir='/tmp/'$myname

if [ ! -d $tmpdir ]
then
  mkdir $tmpdir
  if [ $? -gt 0 ]
  then
    echo failed to make temporary directory: /tmp/`basename $0`
    exit 1
  fi
fi

for each in "$@"
do
  base=`basename "$each"`
  # check for failures and add to array of failures to report on later
  ./cpdf -decompress "$each" -o $tmpdir'/de'"$base"
done
