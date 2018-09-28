#!/bin/bash
# written by Aaron Ciuffo (aaron.ciuffo@gmail.com)
# 2018-05-18

# bulk edit MAP test results; find and replace "Student ID: " with
# "StudentID:" to improve compatability with Alert Solutions in PowerSchool
# for mailing test results to parents

myLongName='com.txoof.'`basename $0`
myName=`basename "$0"`
myDate=`date '+%Y-%m-%d_%H.%M'`

if [ $# -lt 1 ]
then
  echo $myName: edits individual MAP reports into a single file ready for AlertSolutions
#  echo This program depends on a local version of cpdf from Coherent PDF
#  echo Visit http://www.coherentpdf.com/ to purchase
  echo =====================
  echo command line usage: $myName doc1.pdf doc2.pdf doc3.pdf
  echo =====================
  echo point and click usage: drag multiple MAP pdf documents into this window
  exit 0
fi

tmpdir='/tmp/'$myLongName

if [ ! -d $tmpdir ]
then
  mkdir "$tmpdir"
  if [ $? -gt 0 ]
  then
    echo failed to make temporary directory: /tmp/`basename $0`
    exit 1
  fi
else
  rm "$tmpdir"/*.pdf
fi

failure=()
decompressed=()
edited=()
compressed=()
added=()
for each in "$@"
do
  base=`basename "$each"`

  # decompress the PDF with CPDF
  decompFile="$tmpdir"'/de_'"$base"
  if qpdf --stream-data=uncompress "$each" "$decompFile" > /dev/null 2>&1
  #if ./cpdf -decompress "$each" -o "$decompFile" > /dev/null 2>&1
  then
    decompressed+=("$decompFile")
  else
    failure+=('fail decompression: '"$each")
    continue
  fi
done

# edit and compress here
for each in "${decompressed[@]}"
do
  # find and replace with sed
  LANG=C
  if sed -i.bak -e "s/Student ID: /StudentID:/g" "$each"
  then
    edited+=("$each")
    rm "$each".bak
  else
    failure+=('fail find/replace: '"$each")
  fi
  # compress here
  qpdf --compress-streams=y "$each" "$each" > /dev/null
  if [ $? -eq 0 ] || [ $? -eq 3 ]
  #if ./cpdf -compress "$each" -o "$each" > /dev/null 2>&1
  then
    compressed+=("each")
  else
    failure+=('fail to compress: '"$each")
  fi
done

echo merging edited files
# merge into one big pdf
  outPath="$HOME"/Desktop/"$myDate"_MAP.pdf
  qpdf --empty $outPath --pages "$tmpdir"/*.pdf --
  if [ $? -eq 0 ] || [ $? -eq 3 ]
  #if ./cpdf -merge "$tmpdir"/*.pdf -o $outPath 
  then
    echo created merged and edited file: "$outPath"
  else
    echo failed to create a merged file at "$outpath"
  fi

#totalPages=`./cpdf -pages $outPath`
totalPages=`qpdf --show-npages $outPath`

echo ----DECOMPRESSED: ${#decompressed[@]}
echo ----EDITED: ${#edited[@]}
echo ----COMPRESSED: ${#compressed[@]}
echo ----ACTUAL MERGED PAGES: $totalPages
echo ----EXPECTED MERGED PAGES: $(( $#*2 ))

if [ ! $(( $#*2 ))==$totalPages ]
then
  echo WARNING! Some student records were not processed properly
  echo see failures below
fi

if [ ${#failure[@]} -gt 0 ]
then
  echo ---FAILURES: ${#failure[@]}
  for fail in "${failure[@]}"
  do
    echo "$fail"
  done
else
  echo successfully processed all input files
fi

echo cleaning up temporary files
rm -r "$tmpdir"

