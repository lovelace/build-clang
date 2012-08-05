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

# Build LLVM and Clang.
mkdir build # (for building without polluting the source dir)
cd build
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
