#!/bin/bash -ex
# Download all sources for clang, libc++ and libcxxabi.
. config.sh

mkdir -p $SRC
cd $SRC


# Checkout LLVM.
# Change directory to where you want the llvm directory placed.
svn co $LLVM_SVN llvm

# Checkout Clang.
cd $SRC/llvm/tools
svn co $CLANG_SVN clang

# Checkout Compiler-RT.
cd $SRC/llvm/projects
svn co $CRT_SVN compiler-rt

# Checkout LLDB
## FIXME: TODO


# Checkout libc++
cd $SRC
svn checkout $LIBCXX_SVN libcxx


# Checkout libcxxabi
cd $SRC
svn co $LIBCXXABI_SVN libcxxabi
