#!/bin/bash -ex
# Download, build and install libcxxabi (with clang).

# Installation root
PREFIX=/opt/clang

# Source checkout location
SRC=/tmp/src
LIBCXXABI_SRC=$SRC/libcxxabi
LIBCXX_SRC=$SRC/libcxx

# Setup to build with Clang
CC=$PREFIX/bin/clang
CXX=$PREFIX/bin/clang++
export CC CXX

# Checkout the source code.
mkdir -p $SRC
cd $SRC 
svn co http://llvm.org/svn/llvm-project/libcxxabi/trunk libcxxabi
cd libcxxabi

CXXDEFINES="-D_XOPEN_SOURCE=700 -D__STDC_FORMAT_MACROS -D__STDC_LIMIT_MACROS -D__STDC_CONSTANT_MACROS"
CXXINCLUDES="-I $LIBCXXABI_SRC/include -I $LIBCXX_SRC/include"
CXXOPTS="-g -fPIC -nostdinc++ -std=c++11 -Wall -W -Wno-unused-parameter -Wwrite-strings -Wno-long-long -pedantic"
CXXFLAGS="$CXXOPTS $CXXDEFINES $CXXINCLUDES"
LINKOPTS="$CXXOPTS -nodefaultlibs -shared -Wl,--no-undefined"
LIBS="-lpthread -lc -lm -lrt -lgcc_s"

for FILE in $LIBCXXABI_SRC/src/*.cpp; do
    $CXX -DNDEBUG -c $CXXFLAGS $FILE
done

$CXX $CXXOPTS $LINKOPTS -Wl,-soname,libc++abi.so.1 ./*.o -o libc++abi.so.1.0 $LIBS

sudo cp -f ./libc++abi.so.1.0 $PREFIX/lib
sudo ln -f -s $PREFIX/lib/libc++abi.so.1.0 $PREFIX/lib/libc++abi.so.1
sudo ln -f -s $PREFIX/lib/libc++abi.so.1 $PREFIX/lib/libc++abi.so
sudo cp -f $LIBCXXABI_SRC/include/* $PREFIX/include

# mkdir -p src
# pushd src
# ln -s $LIBCXXABI_SRC/src/cxa_exception.hpp
# ln -s $LIBCXXABI_SRC/src/fallback_malloc.ipp
# popd

# cp -r $LIBCXXABI_SRC/test ./test
# pushd ./test
# CC=$ROOT/bin/clang++ OPTIONS="$CXXOPTS $CXXDEFINES -stdlib=libc++ -lc++abi -lpthread -I$PREFIX/include -I$PREFIX/include/c++/v1/ -L$PREFIX/lib -Wl,--rpath,$PREFIX/lib" ./testit
# popd


#-------------------------------------------------------------------------------
#  Notes:
#  
#  If you get this error, install 'libunwind7-dev':
#  
#  src/cxa_exception.hpp:66:9: error: unknown type name '_Unwind_Exception'
#          _Unwind_Exception unwindHeader;
