include(ExternalProject)
ExternalProject_Add(Pixman
    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/ext/pixman
    URL http://cairographics.org/releases/pixman-0.32.4.tar.gz
    CONFIGURE_COMMAND configure
    BUILD_COMMAND make)

ExternalProject_Add(Cairo
    DEPENDS Pixman
    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/ext/cairo
    URL http://cairographics.org/releases/cairo-1.12.16.tar.xz
    CONFIGURE_COMMAND configure
    BUILD_COMMAND make)