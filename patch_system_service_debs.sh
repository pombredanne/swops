set -e 
apt-get install build-essential autoconf automake autotools-dev dh-make debhelper devscripts fakeroot xutils lintian pbuilder dh-apport libwrap0-dev libedit-dev libpam0g-dev libgtk2.0-dev libselinux1-dev libkrb5-dev libck-connector-dev quilt

# Patching SSHD so that usernames can contain slashes 
mkdir -p build
cd build
(apt-get source openssh-server
cd openssh-5.9p1

# update changelog
dch -v 1:5.9p1-5ubuntu1scraperwiki1 "Patch SSHD so that usernames can contain slashes"

# apply patch file
quilt import ../../sshd-allow-slashes-in-user-names.patch
quilt push

debuild -us -uc
)

(apt-get source cron
cd cron-3.0pl1

# update changelog
dch -v 3.0pl1scraperwiki1 "Patch cron so that usernames can contain slashes"

patch < ../../cron-allow-slashes-in-user-names.patch

debuild -us -uc
)
