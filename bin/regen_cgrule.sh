#!/bin/sh

cat /etc/passwd | awk -F: '{ if ($4 == "10000") {print $1 " memory,cpu,cpuacct " $1}}' > /ebs/etc/cgrules.conf
pkill -USR2 cgrulesengd
