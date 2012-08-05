#!/bin/bash -ex

# Installation root
PREFIX=/opt/clang

# Source checkout location
SRC=/tmp/src

mkdir -p $SRC
cd $SRC 

# Checkout LLVM.
# Change directory to where you want the llvm directory placed.
svn co http://llvm.org/svn/llvm-project/llvm/trunk llvm

# Checkout Clang.
cd llvm/tools
svn co http://llvm.org/svn/llvm-project/cfe/trunk clang
cd ../.. # (back to where you started)

# Checkout Compiler-RT.
cd llvm/projects
svn co http://llvm.org/svn/llvm-project/compiler-rt/trunk compiler-rt
cd ../.. # (back to where you started)

# Checkout LLDB
## FIXME: TODO


# Build LLVM and Clang.
mkdir -p build-clang # (for building without polluting the source dir)
cd build-clang
../llvm/configure  --enable-optimized --enable-targets=host-only --prefix=$PREFIX
make

sudo make install

# This builds both LLVM and Clang for debug mode.
#
# Note: For subsequent Clang development, you can just do make at the clang
# directory level. It is also possible to use CMake instead of the makefiles.
# With CMake it is also possible to generate project files for several IDEs:
# Eclipse CDT4, CodeBlocks, Qt-Creator (use the CodeBlocks generator),
# KDevelop3.



#-------------------------------------------------------------------------------
# Notes from acmorrow
# 
# #!/bin/bash
# ( cmake -DCMAKE_BUILD_TYPE=Release
# -DCMAKE_INSTALL_PREFIX=/home/acm/opt
# -DCMAKE_INSTALL_RPATH="\$ORIGIN/../lib" -DBUILD_SHARED_LIBS=true
# -DCMAKE_SHARED_LINKER_FLAGS="-Wl,-z,origin"
# -DLLVM_TARGETS_TO_BUILD="X86" -DLLVM_BINUTILS_INCDIR=/usr/include
# $LLVM_ROOT && make -j2 all && make install ) 2>&1 | tee
# ../llvm.build.log
# 
# Again, the shared libs and origin stuff is *not* the recommended way
# to build llvm. Restricting the targets to X86 speeds up the build.
# Telling it where BINUTILS lives makes it so that if you have the gold
# linker and binutils-dev installed you can use link time optimization
# via -flto.
