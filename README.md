#icCanvas

Free Software digital painting system

##Goals

1. Support infinite-canvas, infinite-resolution rendering.
2. Support an intuitive drawing workflow.
3. Support a wide variety of platforms.

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
    build/          - CMake buildsystem
        modules/    - CMake modules for finding needed external libraries, or
                      (in the future) compiling them ourselves

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
