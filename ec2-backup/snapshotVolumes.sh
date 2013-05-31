#!/bin/bash

while getopts n: o; do
  case "$o" in
    n) SEARCH="$OPTARG";;
    :) echo -n >&2 "$OPTARG requires argument"
       exit 1;;
    [?])  echo >&2 "Usage: $0 -n <partial volume name>"
          exit 1;;
   esac
done


VOLUMES=$(ec2-describe-volumes --show-empty-fields | grep TAG | grep "$SEARCH")
if [[ ("$SEARCH" = "") || ("$?" = "1") ]]; then
  echo >&2 "No volumes matching '$SEARCH' found"
  exit 1
fi


IFS=$'\n'
for volume in $VOLUMES
do
  DATE=$(date "+%Y%m%dT%H%M%S")
  VOLUME_ID=$(echo $volume | awk -F'\t' '{ print $3 }')
  VOLUME_NAME=$(echo $volume | awk -F'\t' '{ print $5 }')
  ec2-create-snapshot -d ${VOLUME_NAME}-${DATE} $VOLUME_ID
done
unset IFS
