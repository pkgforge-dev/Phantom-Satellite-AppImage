# POWER Maintainer: Alexander Baldeck <alex.bldck@gmail.com>
# Maintainer:  Daniel Cook (DCFUKSURMOM) <danielcook30a@gmail.com>

pkgname=phantomsatellite-gtk3
pkgver=34.1.0
pkgrel=1
pkgdesc="Rebranded but otherwise stock fork of Pale Moon with the intention of being free to distribute ."
arch=('x86_64' 'aarch64')
url="https://github.com/DCFUKSURMOM/Phantom-Satellite"
license=('MPL-2.0')
depends=('gtk3' 'dbus-glib' 'desktop-file-utils' 'ffmpeg' 'libxt' 'mime-types' 'alsa-lib'
         'startup-notification')
makedepends=('python2' 'unzip' 'zip' 'yasm' 'libpulse' 'git')
optdepends=('libpulse: PulseAudio audio driver')
options=(!debug !lto)
source=("${pkgname}-${pkgver}.tar.gz::https://github.com/DCFUKSURMOM/Phantom-Satellite/archive/refs/tags/v$pkgver.tar.gz"
        mozconfig.in)
sha256sums=('201b435222892c150f53b847707baddbf26fd035c3fe32f96f1c91fe13f6b397'
            'SKIP')

prepare() {
  cd Phantom-Satellite-$pkgver

  export CFLAGS="-fstack-protector-strong"
  export CXXFLAGS="$CFLAGS -fno-exceptions -fno-rtti"

  cp ${srcdir}/mozconfig.in .mozconfig

  echo "mk_add_options MOZ_MAKE_FLAGS=\"${MAKEFLAGS}\"" >> .mozconfig
  echo "export CFLAGS=\"${CFLAGS}\"" >> .mozconfig
  echo "export CXXFLAGS=\"${CXXFLAGS}\"" >> .mozconfig

  cat .mozconfig
}

build() {
  cd Phantom-Satellite-$pkgver

  # Remove option not supported by ld.gold to prevent configure failure
  export LDFLAGS="${LDFLAGS/-Wl,-z,pack-relative-relocs/}"
  ./mach build
}

package() {
  cd Phantom-Satellite-$pkgver/pmbuild
  make package
  cd dist
  install -d "${pkgdir}"/usr/{bin,lib}
  pwd
  ls -a
  cp -r phantomsatellite/ "${pkgdir}/usr/lib/phantomsatellite"
}
