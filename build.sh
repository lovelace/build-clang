#!/bin/bash -ex
./get-source.sh
./build-clang.sh
./build-cxxabi.sh
./build-libc++.sh
