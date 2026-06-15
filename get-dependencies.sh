#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm  \
	dbus-glib 			 \
	desktop-file-utils   \
	libdbusmenu-gtk3 	 \
	libdbusmenu-glib	 \
	mime-types 			 \
    startup-notification \
	ttf-dejavu

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano ffmpeg-mini gtk2-mini

# If the application needs to be manually built that has to be done down here
mkdir -p ./AppDir/bin
echo "Getting Phantom Satellite binary..."
echo "---------------------------------------------------------------"
if [ "$ARCH" = "x86_64" ]; then
  TARBALL_LINK=$(wget --retry-connrefused --tries=30 \
	  https://api.github.com/repos/DCFUKSURMOM/Phantom-Satellite/releases/latest -O - \
	  | sed 's/[()",{} ]/\n/g' | grep -o -m 1 'https.*releases.*linux-x86_64-gtk3.*tar.xz')
else
  TARBALL_LINK=$(wget --retry-connrefused --tries=30 \
	  https://api.github.com/repos/DCFUKSURMOM/Phantom-Satellite/releases/latest -O - \
	  | sed 's/[()",{} ]/\n/g' | grep -o -m 1 'https.*releases.*linux-aarch64-gtk2.*tar.xz')
  make-aur-package libdbusmenu-gtk2
fi
echo "$TARBALL_LINK" | awk -F'/' '{print $(NF-1)}' | tr -d 'v' > ~/version
wget "$TARBALL_LINK" -O /tmp/phantomsatellite.tar.xz
tar xvf /tmp/phantomsatellite.tar.xz -C /usr/lib
mv -v /usr/lib/phantomsatellite/* ./AppDir/bin
