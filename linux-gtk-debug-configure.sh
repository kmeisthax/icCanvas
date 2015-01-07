#!/bin/bash

mkdir build
mkdir build/linux-gtk-debug
cd build/linux-gtk-debug

cmake -DCMAKE_BUILD_TYPE=Debug ../../frontends/gtk/platform/gnulinux-desktop
