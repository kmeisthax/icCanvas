#!/bin/bash

mkdir build
mkdir build/osx-debug
cd build/osx-debug

cmake -DCMAKE_BUILD_TYPE=Debug ../../frontends/appkit
