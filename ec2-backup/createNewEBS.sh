#!/bin/bash

usage () {
  echo "Usage: $0 -m <juju-machine-id> -s <juju-service> -g <size in GB> -z <region and zone> -d <device>"
}

while [ $# != 0 ]
do
  case $1 in
    (-s) SERVICE=$2; shift 2 ;;
    (-m) MACHINE=$2; shift 2 ;;
    (-g) SIZE=$2; shift 2 ;;
    (-z) ZONE=$2; shift 2 ;;
    (-d) DEVICE=$2; shift 2 ;;
    (-*)  usage 1>&2; exit 99 ;;
    (*) break ;;
  esac
done

: ${SERVICE?$(usage)} ${MACHINE?$(usage)} ${SIZE?$(usage)} ${ZONE?$(usage)} ${DEVICE?$(usage)}

awsenv () {
  echo "AWS_ACCESS_KEY and AWS_SECRET_KEY should be set. Do '. activate' or see ~/sw/charm-secrets/environments.yaml"
}

: ${AWS_SECRET_KEY?$(awsenv)} ${AWS_ACCESS_KEY?$(awsenv)}

# Check that the machine instance exists, before creating volumes so that
# we avoid creating unattached volumes.
ATTACH_TO_INSTANCE=$(./getInstanceByMachine.coffee $MACHINE) || exit 2

CURRENT_VOLUMES=$(ec2-describe-volumes --show-empty-fields | grep TAG | grep "$SERVICE")

max_id=0
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
ec2-attach-volume $NEW_VOLUME_ID -i $ATTACH_TO_INSTANCE -d $DEVICE
