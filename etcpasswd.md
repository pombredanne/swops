Handling of /etc/passwd (for backups)

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
accounts will need to ensur that they use separate ranges of
numbers for creating user accounts.  Should be possible.
