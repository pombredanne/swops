#!/bin/bash

while getopts n: o; do
  case "$o" in
    n) SEARCH="$OPTARG";;
    :) echo -n >&2 "$OPTARG requires argument"
       exit 1;;
    [?])  echo >&2 "Usage: $0 -n <partial volume name e.g. 'live'>"
          exit 1;;
   esac
done

VOLUMES=$(ec2-describe-volumes --show-empty-fields --filter attachment.status=attached | grep TAG | grep "$SEARCH")
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
  #TODO: set owner and restorable permissions to different accounts
  SNAPSHOT_ID=$(ec2-create-snapshot $VOLUME_ID | awk -F'\t' '{print $2}')
  ec2-create-tags $SNAPSHOT_ID --tag "Name=${VOLUME_NAME}:${DATE}"
done
unset IFS

# TODO: Delete snapshots older than date? Can we delete the first full one?!
