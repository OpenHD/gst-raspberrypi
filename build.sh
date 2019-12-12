GSTREAMER_VERSION=1.10.4
QT_VERSION=5.13.1

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
    if [ ! -f gst-plugins-base1.0_${GSTREAMER_VERSION}-1+deb9u1.debian.tar.xz ]; then
	wget http://archive.raspbian.org/raspbian/pool/main/g/gst-plugins-base1.0/gst-plugins-base1.0_${GSTREAMER_VERSION}-1+deb9u1.debian.tar.xz
	wget http://archive.raspbian.org/raspbian/pool/main/g/gst-plugins-base1.0/gst-plugins-base1.0_${GSTREAMER_VERSION}.orig.tar.xz
    fi

    rm -rf gst-plugins-base-${GSTREAMER_VERSION} || true
    tar xvf gst-plugins-base1.0_${GSTREAMER_VERSION}.orig.tar.xz

    cd gst-plugins-base-${GSTREAMER_VERSION} || exit 1
    tar xvf ../gst-plugins-base1.0_${GSTREAMER_VERSION}-1+deb9u1.debian.tar.xz || exit 1

    export DEB_DH_SHLIBDEPS_ARGS_ALL=--dpkg-shlibdeps-params=--ignore-missing-info
    DEB_DH_SHLIBDEPS_ARGS_ALL=--dpkg-shlibdeps-params=--ignore-missing-info \
CFLAGS='-Wno-redundant-decls -I/opt/vc/include -I/opt/vc/include/IL -I/opt/vc/include/interface/vcos/pthreads -I/opt/vc/include/interface/vmcs_host/linux' \
CPPFLAGS='-Wno-redundant-decls -I/opt/vc/include -I/opt/vc/include/IL -I/opt/vc/include/interface/vcos/pthreads -I/opt/vc/include/interface/vmcs_host/linux' \
DEB_BUILD_OPTIONS='parallel=4' debuild -us -uc
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

    export DEB_DH_SHLIBDEPS_ARGS_ALL=--dpkg-shlibdeps-params=--ignore-missing-info
    DEB_DH_SHLIBDEPS_ARGS_ALL=--dpkg-shlibdeps-params=--ignore-missing-info \
PKG_CONFIG_PATH=/opt/Qt${QT_VERSION}/lib/pkgconfig \
CFLAGS='-Wno-redundant-decls -I/opt/vc/include -I/opt/vc/include/IL -I/opt/vc/include/interface/vcos/pthreads -I/opt/vc/include/interface/vmcs_host/linux' \
CPPFLAGS='-Wno-redundant-decls -I/opt/vc/include -I/opt/vc/include/IL -I/opt/vc/include/interface/vcos/pthreads -I/opt/vc/include/interface/vmcs_host/linux' \
DEB_BUILD_OPTIONS='parallel=4' debuild -us -uc
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
    patch -p0 -i ../gst-plugins-bad-${GSTREAMER_VERSION}-rules.patch || exit 1
    patch -p0 -i ../gst-plugins-bad-${GSTREAMER_VERSION}-install.patch || exit 1

    dpkg-source --commit . openhd.patch
    
    export PKG_CONFIG_PATH=/opt/Qt${QT_VERSION}/lib/pkgconfig
    export PATH=/opt/Qt${QT_VERSION}/bin:${PATH}

    export DEB_DH_SHLIBDEPS_ARGS_ALL=--dpkg-shlibdeps-params=--ignore-missing-info
    DEB_DH_SHLIBDEPS_ARGS_ALL=--dpkg-shlibdeps-params=--ignore-missing-info \
CFLAGS='-Wno-redundant-decls -I/opt/vc/include -I/opt/vc/include/IL -I/opt/vc/include/interface/vcos/pthreads -I/opt/vc/include/interface/vmcs_host/linux' \
CPPFLAGS='-Wno-redundant-decls -I/opt/vc/include -I/opt/vc/include/IL -I/opt/vc/include/interface/vcos/pthreads -I/opt/vc/include/interface/vmcs_host/linux' \
LDFLAGS='-L/opt/vc/lib -lEGL -lGLESv2 -lbcm_host' DEB_BUILD_OPTIONS='parallel=4' debuild -us -uc
    cd ..
    dpkg -i *.deb
}



function omx() {
    if [ ! -f gst-omx_${GSTREAMER_VERSION}-1+rtp3.debian.tar.xz ]; then
        wget http://archive.raspberrypi.org/debian/pool/main/g/gst-omx/gst-omx_${GSTREAMER_VERSION}-1+rpt3.debian.tar.xz
        wget http://archive.raspberrypi.org/debian/pool/main/g/gst-omx/gst-omx_${GSTREAMER_VERSION}.orig.tar.xz
    fi
    rm -rf gst-omx-${GSTREAMER_VERSION} || true

    tar xvf gst-omx_${GSTREAMER_VERSION}.orig.tar.xz


    cd gst-omx-${GSTREAMER_VERSION} || exit 1
    tar xvf ../gst-omx_${GSTREAMER_VERSION}-1+rpt3.debian.tar.xz

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

#core
#base
#good
#bad
omx
#cleanup
