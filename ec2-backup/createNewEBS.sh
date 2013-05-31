#!/bin/bash

while getopts m:s:z: o; do
  case "$o" in
    m) UNIT="$OPTARG";;
    s) SIZE="$OPTARG";;
    z) ZONE="$OPTARG";;
    :) echo -n >&2 "$OPTARG requires argument"
       exit 1;;
    [?])  echo >&2 "Usage: $0 <-m juju-unit> <-s size in GB> <-z region and zone>"
          exit 1;;
   esac
done

NEW_VOLUME_ID=$(ec2-create-volume --size $SIZE --availability-zone $ZONE | awk '{print $2}')

ec2-create-tags $NEW_VOLUME_ID -1a2b3c4d --tag "Name=$VOLUME_NAME"
