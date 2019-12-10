GSTREAMER_VERSION=1.14.4
QT_VERSION=5.12

rm *.xz 

function core() {
    if [ ! -f gstreamer1.0_${GSTREAMER_VERSION}-1.debian.tar.xz ]; then
	wget http://archive.raspbian.org/raspbian/pool/main/g/gstreamer1.0/gstreamer1.0_${GSTREAMER_VERSION}-1.debian.tar.xz
	wget http://archive.raspbian.org/raspbian/pool/main/g/gstreamer1.0/gstreamer1.0_${GSTREAMER_VERSION}.orig.tar.xz
    fi
    rm -rf gstreamer-${GSTREAMER_VERSION} || true
    tar xvf gstreamer1.0_${GSTREAMER_VERSION}.orig.tar.xz


    cd gstreamer-${GSTREAMER_VERSION}/ || exit 1
    tar xvf ../gstreamer1.0_${GSTREAMER_VERSION}-1.debian.tar.xz
    DEB_BUILD_OPTIONS='parallel=4' debuild -us -uc
    cd ..
    dpkg -i *.deb
}



function base() {
    if [ ! -f gst-plugins-base1.0_${GSTREAMER_VERSION}-2.debian.tar.xz ]; then
	wget http://archive.raspbian.org/raspbian/pool/main/g/gst-plugins-base1.0/gst-plugins-base1.0_${GSTREAMER_VERSION}-2.debian.tar.xz
	wget http://archive.raspbian.org/raspbian/pool/main/g/gst-plugins-base1.0/gst-plugins-base1.0_${GSTREAMER_VERSION}.orig.tar.xz
    fi


    rm -rf gst-plugins-base-${GSTREAMER_VERSION} || true
    tar xvf gst-plugins-base1.0_${GSTREAMER_VERSION}.orig.tar.xz

    cd gst-plugins-base-${GSTREAMER_VERSION} || exit 1
    tar xvf ../gst-plugins-base1.0_${GSTREAMER_VERSION}-2.debian.tar.xz || exit 1
    sed -i.bak 's/libgraphene-1.0-dev//g' debian/control || exit 1
    patch -p0 -i ../gst-plugins-base-${GSTREAMER_VERSION}.patch || exit 1
    patch -p0 -i ../gst-plugins-base-${GSTREAMER_VERSION}.patch2 || exit 1
    patch -p0 -i ../gst-plugins-base-${GSTREAMER_VERSION}.patch3 || exit 1

    if grep stretch /etc/apt/sources.list; then
        patch -p0 -i ../gst-plugins-base-${GSTREAMER_VERSION}.patch4 || exit 1
    fi

    dpkg-source --commit . openhd.patch
    export DEB_DH_SHLIBDEPS_ARGS_ALL=--dpkg-shlibdeps-params=--ignore-missing-info
    DEB_DH_SHLIBDEPS_ARGS_ALL=--dpkg-shlibdeps-params=--ignore-missing-info \
CFLAGS='-Wno-redundant-decls -I/opt/vc/include -I/opt/vc/include/IL -I/opt/vc/include/interface/vcos/pthreads -I/opt/vc/include/interface/vmcs_host/linux' \
CPPFLAGS='-Wno-redundant-decls -I/opt/vc/include -I/opt/vc/include/IL -I/opt/vc/include/interface/vcos/pthreads -I/opt/vc/include/interface/vmcs_host/linux' \
LDFLAGS='-lEGL -lGLESv2' DEB_BUILD_OPTIONS='parallel=4' debuild -us -uc
    cd ..
    dpkg -i *.deb
}



function good() {
    if [ ! -f gst-plugins-good1.0_${GSTREAMER_VERSION}-1.debian.tar.xz ]; then
	wget http://archive.raspbian.org/raspbian/pool/main/g/gst-plugins-good1.0/gst-plugins-good1.0_${GSTREAMER_VERSION}-1.debian.tar.xz
	wget http://archive.raspbian.org/raspbian/pool/main/g/gst-plugins-good1.0/gst-plugins-good1.0_${GSTREAMER_VERSION}.orig.tar.xz
    fi

    rm -rf gst-plugins-good-${GSTREAMER_VERSION} || true
    tar xvf gst-plugins-good1.0_${GSTREAMER_VERSION}.orig.tar.xz


    cd gst-plugins-good-${GSTREAMER_VERSION} || exit 1
    tar xvf ../gst-plugins-good1.0_${GSTREAMER_VERSION}-1.debian.tar.xz || exit 1
    patch -p0 -i ../gst-plugins-good-${GSTREAMER_VERSION}-rules.patch || exit 1
    patch -p0 -i ../gst-plugins-good-${GSTREAMER_VERSION}-control.patch || exit 1
    patch -p0 -i ../gst-plugins-good-${GSTREAMER_VERSION}-control.in.patch || exit 1

    export PKG_CONFIG_PATH=/opt/Qt${QT_VERSION}/lib/pkgconfig
    export PATH=/opt/Qt${QT_VERSION}/bin:${PATH}
    export DEB_DH_SHLIBDEPS_ARGS_ALL=--dpkg-shlibdeps-params=--ignore-missing-info
    DEB_DH_SHLIBDEPS_ARGS_ALL=--dpkg-shlibdeps-params=--ignore-missing-info \
PKG_CONFIG_PATH=/opt/Qt${QT_VERSION}/lib/pkgconfig \
CFLAGS='-Wno-redundant-decls -I/opt/vc/include -I/opt/vc/include/IL -I/opt/vc/include/interface/vcos/pthreads -I/opt/vc/include/interface/vmcs_host/linux' \
CPPFLAGS='-Wno-redundant-decls -I/opt/vc/include -I/opt/vc/include/IL -I/opt/vc/include/interface/vcos/pthreads -I/opt/vc/include/interface/vmcs_host/linux' \
LDFLAGS='-lEGL -lGLESv2' DEB_BUILD_OPTIONS='parallel=4' debuild -us -uc
    cd ..
    dpkg -i *.deb
}




function bad() {
    if [ ! -f gst-plugins-bad1.0_${GSTREAMER_VERSION}-1.debian.tar.xz ]; then
	wget http://archive.raspbian.org/raspbian/pool/main/g/gst-plugins-bad1.0/gst-plugins-bad1.0_${GSTREAMER_VERSION}-1.debian.tar.xz
	wget http://archive.raspbian.org/raspbian/pool/main/g/gst-plugins-bad1.0/gst-plugins-bad1.0_${GSTREAMER_VERSION}.orig.tar.xz
    fi
    rm -rf gst-plugins-bad-${GSTREAMER_VERSION} || true
    tar xvf gst-plugins-bad1.0_${GSTREAMER_VERSION}.orig.tar.xz


    cd gst-plugins-bad-${GSTREAMER_VERSION} || exit 1
    tar xvf ../gst-plugins-bad1.0_${GSTREAMER_VERSION}-1.debian.tar.xz
    sed -i.bak 's/libnice-dev (>= 0.1.14)//g' debian/control
    sed -i.bak 's/libsrtp2-dev (>= 2.1)//g' debian/control
    sed -i.bak 's/DEB_CONFIGURE_EXTRA_FLAGS +=/DEB_CONFIGURE_EXTRA_FLAGS += --disable-srtp/g' debian/rules

    sed -i.bak 's/libgstsrtp.so/libgstx265.so/g'   debian/gstreamer-plugins-bad.install
    sed -i.bak 's/libgstwebrtc.so/libgstx265.so/g' debian/gstreamer-plugins-bad.install

    sed -i.bak 's/libgstsrtp.so/libgstx265.so/g'   debian/gstreamer1.0-plugins-bad.install
    sed -i.bak 's/libgstwebrtc.so/libgstx265.so/g' debian/gstreamer1.0-plugins-bad.install

CFLAGS='-Wno-redundant-decls -I/opt/vc/include -I/opt/vc/include/IL -I/opt/vc/include/interface/vcos/pthreads -I/opt/vc/include/interface/vmcs_host/linux' \
CPPFLAGS='-Wno-redundant-decls -I/opt/vc/include -I/opt/vc/include/IL -I/opt/vc/include/interface/vcos/pthreads -I/opt/vc/include/interface/vmcs_host/linux' \
LDFLAGS='-L/opt/vc/lib -lbcm_host' DEB_BUILD_OPTIONS='parallel=4' debuild -us -uc
    cd ..
    dpkg -i *.deb
}



function omx() {
    if [ ! -f gst-omx_${GSTREAMER_VERSION}-1.debian.tar.xz ]; then
        wget http://archive.raspberrypi.org/debian/pool/main/g/gst-omx/gst-omx_${GSTREAMER_VERSION}-1+rpt1.debian.tar.xz
        wget http://archive.raspberrypi.org/debian/pool/main/g/gst-omx/gst-omx_${GSTREAMER_VERSION}.orig.tar.xz
    fi
    rm -rf gst-omx-${GSTREAMER_VERSION} || true

    tar xvf gst-omx_${GSTREAMER_VERSION}.orig.tar.xz


    cd gst-omx-${GSTREAMER_VERSION} || exit 1
    tar xvf ../gst-omx_${GSTREAMER_VERSION}-1+rpt1.debian.tar.xz

CFLAGS='-DOMX_SKIP64BIT -Wno-redundant-decls -I/opt/vc/include -I/opt/vc/include/IL -I/opt/vc/include/interface/vcos/pthreads -I/opt/vc/include/interface/vmcs_host/linux' \
CPPFLAGS='-Wno-redundant-decls -I/opt/vc/include -I/opt/vc/include/IL -I/opt/vc/include/interface/vcos/pthreads -I/opt/vc/include/interface/vmcs_host/linux' \
LDFLAGS='-L/opt/vc/lib -lbcm_host' DEB_BUILD_OPTIONS='parallel=4' debuild -us -uc
    cd ..
    dpkg -i *.deb
}


function cleanup() {
    rm -rf gstreamer-${GSTREAMER_VERSION} || true
    rm -rf gst-plugins-base-${GSTREAMER_VERSION} || true
    rm -rf gst-plugins-good-${GSTREAMER_VERSION} || true
    rm -rf gst-plugins-bad-${GSTREAMER_VERSION} || true
    rm -rf gst-omx-${GSTREAMER_VERSION} || true

    rm gstreamer-${GSTREAMER_VERSION}.tar.xz || true
    rm gst-plugins-base-${GSTREAMER_VERSION}.tar.xz || true
    rm gst-plugins-good-${GSTREAMER_VERSION}.tar.xz || true
    rm gst-plugins-bad-${GSTREAMER_VERSION}.tar.xz || true
    rm gst-omx-${GSTREAMER_VERSION}.tar.xz || true
}

core
base
good
bad
omx
cleanup
