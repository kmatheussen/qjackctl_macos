#!/bin/sh

unset PKG_CONFIG_PATH

set -e

P=x86_64-apple-darwin17

CC=$P-clang
CXX=$P-clang++
LINKER=$P-clang++

MACOSX_DEPLOYMENT_TARGET=10.12



export JACKOPT="`$P-pkg-config --cflags jack` -DNO_JACK_METADATA"

export CFLAGS=
export CPPFLAGS=
export LDFLAGS=
export CPPFLAGS=
export CXXFLAGS=

unset QT_QPA_PLATFORM_PLUGIN_PATH
unset QT5DIR

MYCFLAGS="-mtune=generic -mfpmath=sse -msse2 -O3 -fvisibility=default -mmacosx-version-min=$MACOSX_DEPLOYMENT_TARGET `$P-pkg-config --cflags Qt5Gui --cflags Qt5Core --cflags Qt5Widgets --cflags Qt5Network` $JACKOPT -DQT_NO_DEBUG -std=gnu++11"

MYCPPFLAGS="$MYCFLAGS"
MYLDFLAGS="`$P-pkg-config --libs Qt5Gui --libs Qt5Core --libs Qt5Widgets --libs Qt5Network --libs Qt5Location --libs Qt5Xml` -framework CoreAudio -framework CoreFoundation -L/opt/local/lib -ljack"

rm -fr qjackctl

tar xvzf qjackctl-qjackctl_0_6_0.tar.gz 
mv qjackctl-qjackctl_0_6_0 qjackctl

cp config.h qjackctl/src/

cd qjackctl
patch -p1 <../qjackctl.diff
patch -p1 <../qjackctl_defaults.diff
cp ../qjackctlPeriodsSpinBox.h src/
cp ../qjackctlPeriodsSpinBox.cpp src/

qmake-qt5

make clean

qmake-qt5


export OSXCROSS_NO_INCLUDE_PATH_WARNINGS=1


set +e

#compile (linking fails)
CFLAGS="$MYCFLAGS" CPPFLAGS="$MYCPPFLAGS" CXXFLAGS="$MYCPPFLAGS" LDFLAGS="$MYLDFLAGS" CC=$CC CXX=$CXX LINK=$LINKER AR=$P-ar RANLIB=$P-ranlib make CC=$CC CXX=$CXX LINK=$LINKER CFLAGS="$MYCFLAGS" CPPFLAGS="$MYCPPFLAGS" CXXFLAGS="$MYCPPFLAGS" -j8

set -e

#link manually
$LINKER src/.obj/*.o $MYLDFLAGS -o qjackctl

$P-otool -L qjackctl

$P-otool -L qjackctl

cd ..

rm -fr QJackCtl.app
cp -a QJackCtl.app_template QJackCtl.app
mkdir QJackCtl.app/Contents/lib
mkdir QJackCtl.app/Contents/MacOS

cp -f qjackctl/qjackctl QJackCtl.app/Contents/MacOS/

./change_dylib_paths.sh QJackCtl.app/Contents/MacOS/qjackctl

#change_dylib_paths.sh
#/opt/local/libexec/qt5/lib/QtPositioningQuick.framework/QtPositioningQuick

fix_qt_lib() {
    cp /opt/local/libexec/qt5/lib/$1.framework/$1 QJackCtl.app/Contents/lib/
    ./change_dylib_paths.sh QJackCtl.app/Contents/lib/$1
}

fix_qt_lib QtGui
fix_qt_lib QtCore
fix_qt_lib QtWidgets
fix_qt_lib QtNetwork
fix_qt_lib QtLocation
fix_qt_lib QtPositioning
fix_qt_lib QtQuick
fix_qt_lib QtPositioningQuick
fix_qt_lib QtQml
fix_qt_lib QtXml
fix_qt_lib QtPrintSupport
fix_qt_lib QtDBus


fix_lib() {
    cp /opt/local/lib/$1.dylib QJackCtl.app/Contents/lib/
    ./change_dylib_paths.sh QJackCtl.app/Contents/lib/$1.dylib
}

fix_lib libz.1
fix_lib libpng16.16
fix_lib libharfbuzz.0
fix_lib libicui18n.58
fix_lib libicuuc.58
fix_lib libicui18n.58
fix_lib libicuuc.58
fix_lib libicudata.58
fix_lib libpcre2-16.0
fix_lib libgthread-2.0.0
fix_lib libglib-2.0.0
fix_lib libintl.8
fix_lib libssl.1.0.0
fix_lib libcrypto.1.0.0
fix_lib libpcre.1
fix_lib libfreetype.6
fix_lib libgraphite2.3
fix_lib libbz2.1.0
fix_lib libdbus-1.3
#fix_lib lib
#fix_lib lib
#fix_lib lib
#fix_lib lib


mkdir QJackCtl.app/Contents/MacOS/platforms
cp /opt/local/libexec/qt5/plugins/platforms/libqcocoa.dylib QJackCtl.app/Contents/MacOS/platforms/

./change_dylib_paths.sh QJackCtl.app/Contents/MacOS/platforms/libqcocoa.dylib

