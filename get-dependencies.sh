#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm  \
	dbus-glib 			 \
	desktop-file-utils   \
    gtk3 				 \
	mime-types 			 \
    startup-notification

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# If the application needs to be manually built that has to be done down here
mkdir -p ./AppDir/bin
if [ "$ARCH" = "x86_64" ]; then
  echo "Getting Phantom Satellite binary..."
  echo "---------------------------------------------------------------"
  TARBALL_LINK=$(wget --retry-connrefused --tries=30 \
	  https://api.github.com/repos/DCFUKSURMOM/Phantom-Satellite/releases/latest -O - \
	  | sed 's/[()",{} ]/\n/g' | grep -o -m 1 'https.*releases.*linux-x86_64-gtk3.*tar.xz'
  )
  echo "$TARBALL_LINK" | awk -F'/' '{print $(NF-1)}' | tr -d 'v' > ~/version
  wget "$TARBALL_LINK" -O /tmp/phantomsatellite.tar.xz
  tar xvf /tmp/phantomsatellite.tar.xz -C /usr/lib
  rm -f /tmp/phantomsatellite.tar.xz
else
	make-aur-package openssl-1.1
	PRE_BUILD_CMDS='sed -i "s/^check() {/disabled_check() {/" ./PKGBUILD' make-aur-package python2
	make-aur-package gtk2
	make-aur-package
fi
mv -v /usr/lib/phantomsatellite/* ./AppDir/bin
