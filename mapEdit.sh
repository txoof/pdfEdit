#!/bin/bash
# written by Aaron Ciuffo (aaron.ciuffo@gmail.com)
# 2018-05-18

# bulk edit MAP test results; find and replace "Student ID: " with
# "StudentID:" to improve compatability with Alert Solutions in PowerSchool
# for mailing test results to parents

myLongName='com.txoof.'`basename $0`
myName=$0

if [ $# -lt 1 ]
then
  echo $myName: edit individual MAP reports into file ready for AlertSolutions
  echo usage: $myName doc1.pdf doc2.pdf doc3.pdf
  echo supply at least one file name to process. exiting.
  exit 0
fi

tmpdir='/tmp/'$myLongName

if [ ! -d $tmpdir ]
then
  mkdir $tmpdir
  if [ $? -gt 0 ]
  then
    echo failed to make temporary directory: /tmp/`basename $0`
    exit 1
  fi
fi

echo found $# files 
failure=()
decompressed=()
edited=()
compressed=()
added=()
for each in "$@"
do
  base=`basename "$each"`

  # decompress the PDF with CPDF
  decompFile="$tmpdir"'/de'"$base"
  if ./cpdf -decompress "$each" -o "$decompFile" > /dev/null 2>&1
  then
    decompressed+=("$decompFile")
  else
    failure+=("$each")
    echo FAILURE: "$each"
    continue
  fi
done

for each in $decompressed
do
  # find and replace with sed
  if sed -e "s/Student ID: /StudentID:/g"
  then
    failure+=("$each")
  else
    edited+=("$each")
  fi

  # compress the PDF


done

# combine the individual PDFs into a massive PDF

for fail in "$failure"
do
  echo Failed to process: "$fail"
done

echo ----DECOMPRESSED: ${#decompressed[@]}----
echo ----EDITED: ${#edited[@]}----
