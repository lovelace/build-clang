#!/bin/bash -ex
# Download, build and install libc++.
. config.sh

# Setup to build with Clang
CC=$PREFIX/bin/clang
CXX=$PREFIX/bin/clang++
export CC CXX

LIBCXX_SRC=$SRC/libcxx

# Old method of building.
## TRIPLE=x86_64-unknown-linux-gnu
## export TRIPLE
## cd libcxx/lib && ./buildit


# Build out of source.
cd $SRC
rm -rf build-libcxx
mkdir -p build-libcxx
cd build-libcxx

CXXDEFINES="-D_XOPEN_SOURCE=700 -D__STDC_FORMAT_MACROS -D__STDC_LIMIT_MACROS -D__STDC_CONSTANT_MACROS"
CXXFLAGS="$CXXDEFINES -I$PREFIX/include -march=native -mtune=native"
LINKOPTS="-L$PREFIX/lib -lc++abi -Wl,-z,origin -Wl,--no-undefined"
export CXXDEFINES CXXFLAGS LINKOPTS

( cmake -DLIT_EXECUTABLE=$PREFIX/utils/lit/lit.py	\
        -DCMAKE_INSTALL_PREFIX=$PREFIX			\
        -DCMAKE_BUILD_TYPE=RelWithDebInfo		\
        -DCMAKE_SHARED_LINKER_FLAGS="$LINKOPTS"		\
         $LIBCXX_SRC &&					\
make -j2 all VERBOSE=1 &&				\
sudo make install )						\
2>&1 | tee ../libcxx.build.log

## -std=c++11
## -stdlib=libc++
# You have to tell the linker to link against libc++ instead of libstdc++ as well.
