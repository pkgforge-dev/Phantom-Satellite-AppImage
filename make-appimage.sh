#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q phantomsatellite-gtk3 | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=https://raw.githubusercontent.com/DCFUKSURMOM/Phantom-Satellite/refs/heads/master/phantomsatellite/branding/unofficial/mozicon128.png
export DESKTOP=https://raw.githubusercontent.com/DCFUKSURMOM/Phantom-Satellite/refs/heads/master/phantomsatellite/branding/unofficial/browser.desktop
export DEPLOY_GTK=1
export GTK_DIR=gtk-3.0
export DEPLOY_OPENGL=1

# Deploy dependencies
quick-sharun ./AppDir/bin/phantomsatellite

# Additional changes can be done in between here
mkdir -p ./AppDir/share/fonts/TTF
cp -v /usr/share/fonts/TTF/DejaVuSans.ttf ./AppDir/share/fonts/TTF

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --simple-test ./dist/*.AppImage
