#!/bin/bash -ex
# Download all sources for clang, libc++ and libcxxabi.
. config.sh

mkdir -p $SRC
cd $SRC


# Checkout LLVM.
# Change directory to where you want the llvm directory placed.
svn co http://llvm.org/svn/llvm-project/llvm/trunk llvm

# Checkout Clang.
cd $SRC/llvm/tools
svn co http://llvm.org/svn/llvm-project/cfe/trunk clang

# Checkout Compiler-RT.
cd $SRC/llvm/projects
svn co http://llvm.org/svn/llvm-project/compiler-rt/trunk compiler-rt

# Checkout LLDB
## FIXME: TODO


# Checkout libc++
cd $SRC
svn checkout http://llvm.org/svn/llvm-project/libcxx/trunk libcxx


# Checkout libcxxabi
cd $SRC
svn co http://llvm.org/svn/llvm-project/libcxxabi/trunk libcxxabi
