include(ExternalProject)

ExternalProject_Add(pkg_config
    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/ext/pkg_config
    URL http://pkgconfig.freedesktop.org/releases/pkg-config-0.28.tar.gz
    CONFIGURE_COMMAND <SOURCE_DIR>/configure --with-internal-glib
        --prefix=<INSTALL_DIR>
    BUILD_COMMAND make)

ExternalProject_Add(Libpng
    DEPENDS pkg_config
    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/ext/libpng
    URL ftp://ftp.simplesystems.org/pub/libpng/png/src/libpng16/libpng-1.6.16.tar.gz
    CONFIGURE_COMMAND ${PARENT_PROJECT_DIR}/tools/fakepkgcfg.py ${CMAKE_CURRENT_BINARY_DIR} <SOURCE_DIR>/configure
        --prefix=<INSTALL_DIR> --disable-dependency-tracking
    BUILD_COMMAND ${PARENT_PROJECT_DIR}/tools/fakepkgcfg.py ${CMAKE_CURRENT_BINARY_DIR} make
    INSTALL_COMMAND ${PARENT_PROJECT_DIR}/tools/fakepkgcfg.py ${CMAKE_CURRENT_BINARY_DIR} make install)

ExternalProject_Add(Pixman
    DEPENDS pkg_config
    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/ext/pixman
    URL http://cairographics.org/releases/pixman-0.32.4.tar.gz
    CONFIGURE_COMMAND ${PARENT_PROJECT_DIR}/tools/fakepkgcfg.py ${CMAKE_CURRENT_BINARY_DIR} <SOURCE_DIR>/configure
        --prefix=<INSTALL_DIR> --disable-dependency-tracking
    BUILD_COMMAND ${PARENT_PROJECT_DIR}/tools/fakepkgcfg.py ${CMAKE_CURRENT_BINARY_DIR} make
    INSTALL_COMMAND ${PARENT_PROJECT_DIR}/tools/fakepkgcfg.py ${CMAKE_CURRENT_BINARY_DIR} make install)

ExternalProject_Add(Cairo
    DEPENDS Pixman Libpng 
    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/ext/cairo
    URL http://cairographics.org/releases/cairo-1.12.16.tar.xz
    DOWNLOAD_COMMAND ${PARENT_PROJECT_DIR}/tools/extractxz.py http://cairographics.org/releases/cairo-1.12.16.tar.xz <SOURCE_DIR> Cairo
    CONFIGURE_COMMAND ${PARENT_PROJECT_DIR}/tools/fakepkgcfg.py ${CMAKE_CURRENT_BINARY_DIR} <SOURCE_DIR>/configure
        --prefix=<INSTALL_DIR> --disable-xlib --disable-ft --disable-dependency-tracking
    BUILD_COMMAND ${PARENT_PROJECT_DIR}/tools/fakepkgcfg.py ${CMAKE_CURRENT_BINARY_DIR} make
    INSTALL_COMMAND ${PARENT_PROJECT_DIR}/tools/fakepkgcfg.py ${CMAKE_CURRENT_BINARY_DIR} make install)

set(CAIRO_INCLUDE_DIRS ${CMAKE_BINARY_DIR}/ext/cairo/include/cairo)
set(CAIRO_LIBRARIES ${CMAKE_CURRENT_BINARY_DIR}/ext/cairo/lib/libcairo.dylib)