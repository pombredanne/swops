#!/bin/bash

while getopts m:s:z:g:d: o; do
  case "$o" in
    s) SERVICE="$OPTARG";;
    m) MACHINE="$OPTARG";;
    g) SIZE="$OPTARG";;
    z) ZONE="$OPTARG";;
    d) DEVICE="$OPTARG";;
    :) echo -n >&2 "$OPTARG requires argument"
       exit 1;;
    [?])  echo >&2 "Usage: $0 <-m juju-machine-id> <-s juju-service> <-g size in GB> <-z region and zone> <-d device>"
          exit 1;;
   esac
done

CURRENT_VOLUMES=$(ec2-describe-volumes --show-empty-fields | grep TAG | grep "$SERVICE")
if [ "$?" = "1" ]; then
  echo >&2 "Service not found"
  exit 1
fi

IFS='\n'
for volume in $CURRENT_VOLUMES
do
  max_id=$(echo $volume | awk -F'\t' '{ print $5 }' | awk -F: '{print $2}' | sort -n | tail -1)
done
IFS=' '

# Create new volume, give it a name of service:n
NEW_VOLUME_ID=$(ec2-create-volume --size $SIZE --availability-zone $ZONE | awk '{print $2}')
TAG_RESULT=$(ec2-create-tags $NEW_VOLUME_ID --tag "Name=${SERVICE}:$(($max_id + 1))")


# Attach the volume to the machine
ATTACH_TO_INSTANCE=$(./getInstanceByMachine.coffee $MACHINE)
ec2-attach-volume $NEW_VOLUME_ID -i $ATTACH_TO_INSTANCE -d $DEVICE
