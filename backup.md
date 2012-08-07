Backups
=======

What is backed up?
------------------
The databases stored on mongohq.com are backed up daily to the
paid Amazon S3 account scraperwiki holds, with 5 backups being
retained at any one time. This is performed automatically by
mongohq.

See the mongohq.com dashboard to access the backups.

The /home directories of all boxes (as stored on the glusterfs),
sshkeys of all boxes and /etc of the 'live' linode are compressed
at 0100 and transferred to kippax at 0300, with 1 backup being
retained at any one time.

As of 2012-08 there must only be one machine configured to make
backups of box (meta)data.

See boxecutor-dev/010_setup_backups.r.sh for the details.

Handling of /etc/passwd (for backups)
-------------------------------------

We do not backup /opt/basejail/etc/passwd or /etc/passwd on any
of the boxecutor machines.

That's because when we restore from backup the mapping from user
number to user name is effectively stored in the tar file (each
box's directory has a particular name and is owned by a
particular user id).

So we can reconstruct /etc/passwd from a backup, and it's better
to save writing that script for later, when we actually restore
from backup.  There's no saving to be had by writing the script
now.

In the future, any live boxecutors that are creating user
accounts will need to ensure that they use separate ranges of
numbers for creating user accounts.  Should be possible.
