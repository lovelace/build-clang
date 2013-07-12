#!/bin/bash -ex
# Common variables.

# Installation root
PREFIX=/opt/clang

# Source checkout location
SRC=/tmp/src

# What version to check out (if you prefer not to follow trunk)
#VERSION=trunk
#ABI_VERSION=trunk
VERSION=tags/RELEASE_33/final
ABI_VERSION=branches/release_32

# Subversion location of LLVM
LLVM_SVN=http://llvm.org/svn/llvm-project/llvm/$VERSION

# Subversion location of Clang
CLANG_SVN=http://llvm.org/svn/llvm-project/cfe/$VERSION

# Subversion location of Compiler-RT
CRT_SVN=http://llvm.org/svn/llvm-project/compiler-rt/$VERSION

# Subversion location of libcxx
LIBCXX_SVN=http://llvm.org/svn/llvm-project/libcxx/$VERSION

# Subversion location of libcxxabi
LIBCXXABI_SVN=http://llvm.org/svn/llvm-project/libcxxabi/$ABI_VERSION



