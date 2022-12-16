#!/bin/sh

# Open Source List && Output File Path
openSourceList="Tuist/Dependencies/Lockfiles/Package.resolved"
outputFilePath="Trinap/Resources/OpenSourceList.json"

pwd

# Check File Exists
if [ ! -e $openSourceList ]
then
    echo "Package.resolved not exists."
    exit -1
fi

# Parse to String
json="`cat ${openSourceList}`"

# Remove first 2 lines
json=`echo "${json}" | sed -e '1,2d'`

# Remove last 3 lines
lineCount=`echo "${json}" | wc -l`
json=`echo "${json}" | sed -e "$((lineCount-2)),$((lineCount))d"`

# Configure as Array
json=`echo "[\n${json}\n]"`

# Create file if not exists
if [ ! -e $outputFilePath ]
then
    touch $outputFilePath
fi

# Put contents
echo "${json}" > $outputFilePath