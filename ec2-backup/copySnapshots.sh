#!/bin/sh

while getopts s:t: o; do
  case "$o" in
    s) SOURCE_REGION="$OPTARG";;
    t) TARGET_REGION="$OPTARG";;
    :) echo -n >&2 "$OPTARG requires argument"
       exit 1;;
    [?])  echo >&2 "Usage: $0 -s <source region> -t <target region>"
          echo >&2 "e.g. $0 -s us-east-1 -t eu-west-1"
          exit 1;;
   esac
done


SOURCE_SNAPSHOTS=$(ec2-describe-snapshots --region $SOURCE_REGION --show-empty-fields --filter status=completed| grep TAG | grep -v "\-COPIED")
TARGET_SNAPSHOTS=$(ec2-describe-snapshots --region $TARGET_REGION | grep TAG )

printf '%s\n' "$SOURCE_SNAPSHOTS" |
while read snapshot
do
  SNAPSHOT_ID=$(echo $snapshot | awk '{ print $3 }')
  SNAPSHOT_NAME=$(echo $snapshot | awk '{ print $5 }')

  if ! echo "$TARGET_SNAPSHOTS" | grep -q "$SNAPSHOT_NAME"; then
    SNAPSHOT_ID=$(ec2-copy-snapshot --source-region $SOURCE_REGION --source-snapshot-id $SNAPSHOT_ID --region $TARGET_REGION | awk -F'\t' '{print $2}')
    ec2-create-tags $SNAPSHOT_ID --region $TARGET_REGION --tag "Name=${SNAPSHOT_NAME}"
  fi
done
