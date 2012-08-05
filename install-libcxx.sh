#!/bin/bash -ex
# Download, build and install libc++.

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
svn checkout http://llvm.org/svn/llvm-project/libcxx/trunk libcxx

# Old method of building.
## TRIPLE=x86_64-unknown-linux-gnu
## export TRIPLE
## cd libcxx/lib && ./buildit


cd libcxx
CXXDEFINES="-D_XOPEN_SOURCE=700 -D__STDC_FORMAT_MACROS -D__STDC_LIMIT_MACROS -D__STDC_CONSTANT_MACROS"
CXXFLAGS="$CXXDEFINES -I$PREFIX/include -march=native -mtune=native"
LINKOPTS="-L$PREFIX/lib -lc++abi -Wl,-z,origin -Wl,--no-undefined"
export CXXDEFINES CXXFLAGS LINKOPTS

( cmake -DLIT_EXECUTABLE=$LLVM_PREFIX/utils/lit/lit.py	\
        -DCMAKE_BUILD_TYPE=Debug			\
        -DCMAKE_PREFIX_PREFIX=$PREFIX/			\
        -DCMAKE_PREFIX_RPATH=\$ORIGIN/../lib		\
        -DCMAKE_SHARED_LINKER_FLAGS="$LINKOPTS"		\
         $LIBCXX_PREFIX &&				\
make -j2 all VERBOSE=1 &&				\
make install )						\
2>&1 | tee ../libcxx.build.log

## -std=c++11
## -stdlib=libc++
# You have to tell the linker to link against libc++ instead of libstdc++ as well.
