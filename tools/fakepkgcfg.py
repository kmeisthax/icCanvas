#!/usr/bin/env python

import subprocess, os, os.path, sys

def ensure_dir(d):
    if not os.path.exists(d):
        os.makedirs(d)

builddir = sys.argv[1]
subcmd = sys.argv[2:]

subenv = {}

for k, v in os.environ.items():
    subenv[k] = v

subenv["PKG_CONFIG"] = os.path.join(builddir, "ext", "pkg_config", "bin", "pkg-config")
subenv["PKG_CONFIG_PATH"] = os.path.join(builddir, "ext", "libpng", "lib", "pkgconfig") + ":" + os.path.join(builddir, "ext", "pixman", "lib", "pkgconfig") + ":" + os.path.join(builddir, "ext", "cairo", "lib", "pkgconfig")

print subcmd
print subenv

sys.exit(subprocess.call(subcmd, env=subenv))
