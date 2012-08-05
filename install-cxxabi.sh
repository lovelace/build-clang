#!/bin/bash -ex
# Download, build and install libcxxabi (with clang).

# Installation root
PREFIX=/opt 
LIBCXXABI_PREFIX=$PREFIX

# Source checkout location
SRC=/tmp/src

# Setup to build with Clang
CC=$PREFIX/bin/clang
CXX=$PREFIX/bin/clang++

# Checkout the source code.
mkdir -p $SRC
cd $SRC 
svn co http://llvm.org/svn/llvm-project/libcxxabi/trunk libcxxabi


# Note: When libc++ can handle -U_GNU_SOURCE, add that here.
CXXDEFINES="-D_XOPEN_SOURCE=700 -D__STDC_FORMAT_MACROS -D__STDC_LIMIT_MACROS -D__STDC_CONSTANT_MACROS"
CXXINCLUDES="-I $LIBCXXABI_PREFIX/include  -I $LIBCXX_PREFIX/include/"
CXXOPTS="-march=native -mtune=native -g -fPIC -nostdinc++ -std=c++11 -Wall -W -Wno-unused-parameter -Wwrite-strings -Wno-long-long -pedantic"
CXXFLAGS="$CXXOPTS $CXXDEFINES $CXXINCLUDES"
LINKOPTS="$CXXOPTS -nodefaultlibs -shared -Wl,--no-undefined"
LIBS="-lpthread -lc -lm -lrt -lgcc_s"

for FILE in $LIBCXXABI_PREFIX/src/*.cpp; do
    $CXX -DNDEBUG -c $CXXFLAGS $FILE
done

$CXX $CXXOPTS $LINKOPTS -Wl,-soname,libc++abi.so.1 ./*.o -o
libc++abi.so.1.0 $LIBS

cp -f ./libc++abi.so.1.0 $PREFIX/lib
ln -f -s $PREFIX/lib/libc++abi.so.1.0 $PREFIX/lib/libc++abi.so.1
ln -f -s $PREFIX/lib/libc++abi.so.1 $PREFIX/lib/libc++abi.so
cp -f $LIBCXXABI_PREFIX/include/* $PREFIX/include

mkdir src
pushd src
ln -s $LIBCXXABI_PREFIX/src/cxa_exception.hpp
ln -s $LIBCXXABI_PREFIX/src/fallback_malloc.ipp
popd

cp -r $LIBCXXABI_PREFIX/test ./test
pushd ./test
CC=$ROOT/bin/clang++ OPTIONS="$CXXOPTS $CXXDEFINES -stdlib=libc++
-lc++abi -lpthread -I$PREFIX/include
-I$PREFIX/include/c++/v1/ -L$PREFIX/lib
-Wl,--rpath,$PREFIX/lib" ./testit
popd
