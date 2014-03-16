#icCanvas

Free Software digital painting system

##Building

1. Install cmake
2. Run the script of your choice to create the build system (xxx-configure)
3. Compile icCanvas with the generated build system (xxx-make)
4. Gather build products together to create installable package (xxx-package)

Build products will appear in the build/xxx directory for your platform.

##Requirements

* ###Core library

    The core library, icCanvasManager, can be built using a C++11 compiler and
    cmake. It must be built on a system with cairo and development headers for
    cairo present; future plans for non-system Cairo platforms is to compile
    and ship our own Cairo build.

    * ####Objective-C port

        Requires Objective-C compiler that can parse C++11 headers.

* ###AppKit frontend

    This frontend targets the OSX system UI toolkit, AppKit. Makes one
    icCanvas.app with icCanvasManager.framework inside.

    Not currently tested for or intended for use with GNUStep or other
    non-Apple Objective-C environments.

##Architecture

To support ports to a wide variety of platforms and still have decent UX, we
plan to use multiple front-ends on top of a relatvely platform-neutral inner
library. Additionally, foreign function APIs may be created to support
frontend code written in languages other than C++. (e.g. Obj-C API for a Cocoa
port; GObject API for a GTK port; etc)

    include/        - Core library includes
    src/            - Core library source
    api/xxx/        - Core library FFI for programming language xxx
    frontends/xxx/  - Program frontend for widget toolkit xxx
        include/    - Frontend includes
        src/        - Frontend source
    ext/xxx/        - Git submodule for external library xxx
    build/          - CMake buildsystem files.
                      Contains files built by cmake or it's child buildsystem.
    modules/        - CMake modules for finding needed external libraries, or
                      (in the future) compiling them ourselves
    xxx-configure.* - Scripts for running CMake files for platform xxx
    xxx-make.*      - Scripts for compiling using the resulting CMake project
    xxx-package.*   - Scripts for packaging build products for distribution

###Sobmodules
Note: This project contains submodules. Currently we do not require them but
future frontend ports may mandate compiling and including an external library,
which will be downloaded with submodules. For those platforms building will
require the use of some submodule commands:

    git submodule update

Please do not use the submodules contained in ext/xxx to develop those
external libraries, no matter how tempting. It will only cause you pain. Only
use the submodule repos to update the superproject's reference commit to the
next stable version.

##Features

1. Infinite-canvas, infinite-resolution rendering.
2. Intuitive drawing workflow.
3. Wide variety of platform support.

###Infinite resolution canvas
The goal of icCanvas is to provide a painting-friendly drawing workflow while
still maintaining some advantages of a vector format. As such, instead of
storing vector shapes, we store individual action history and replay it as
needed. As a result, we can support rendering at higher zoom factors with no
loss of quality as one might see in a traditional raster art program.

Likewise, we also support an infinite canvas. In reality, it's a canvas 2^32
by 2^32 samples big, of which we arbitrarily define some number of samples as
being 1 mm on that canvas. Ideally, setting a default "scale" of 65536 samples
to 1 mm will give us a drawing 65 meters big with more zoom than anyone needs,
but this scale will be user-definable and only used to define what 100% zoom
means.

###Intuitive drawing workflow
The primary means of drawing will be through brush strokes already fmailiar to
users of raster editing programs. Vector shapes may be supported in the future
but the primary use case is "raster-like" drawing.

We also plan to support pen input devices including those with support for
pressure and angle sensors.
