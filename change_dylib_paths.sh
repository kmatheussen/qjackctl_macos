#!/bin/sh

P=x86_64-apple-darwin17

#EXE=osxtest.bin
EXE=$1

# Based on a comment from Akos Cz at http://stackoverflow.com/questions/4677044/how-to-use-dylib-in-mac-os-x-c

# All libraries in /opt/local/
DYLIBS=`$P-otool -L $EXE | grep "\/opt\/local\/" | awk -F' ' '{ print $1 }'`

# All libraries from /opt/local
#DYLIBS="$DYLIBS `$P-otool -L $EXE | grep "\/opt\/local\/" | awk -F' ' '{ print $1 }'`"

for dylib in $DYLIBS; do
    echo $dylib
    if echo $dylib | grep libjack ; then
        echo "skipping"
    else
        echo $P-install_name_tool -change $dylib \@executable_path/../lib/`basename $dylib` $EXE;
        $P-install_name_tool -change $dylib \@executable_path/../lib/`basename $dylib` $EXE;
        echo
    fi
done;

