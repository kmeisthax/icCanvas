cmake_minimum_required(VERSION 2.8)

set(PARENT_PROJECT_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../../../..")
set(GTK_PROJECT_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../..")
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${PARENT_PROJECT_DIR}/modules")

include(UseVala REQUIRED)
find_package(Vala REQUIRED)

find_package(Eigen)
find_package(Cairo)

if(!CAIRO_FOUND)
    message(FATAL_ERROR "Need Cairo to compile.")
endif()

include(${PARENT_PROJECT_DIR}/CMakeLists.txt)
include(${PARENT_PROJECT_DIR}/api/c/CMakeLists.txt)
include(${PARENT_PROJECT_DIR}/api/vala/CMakeLists.txt)

find_package(PkgConfig)
pkg_check_modules(GTK gtk+-3.0)
add_definitions(${GTK_CFLAGS} ${GTK_CFLAGS_OTHER})
link_libraries(${GTK_LIBRARIES})
link_directories(${GTK_LIBRARY_DIRS})
include_directories(${GTK_INCLUDE_DIRS})

pkg_check_modules(GEE gee-1.0)
link_libraries(${GEE_LIBRARIES})
link_directories(${GEE_LIBRARY_DIRS})
include_directories(${GEE_INCLUDE_DIRS})

file(GLOB ICGTK_SRC_VALA RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} ${GTK_PROJECT_DIR}/src/*.vala)
include_directories(include)

set(ICGTK_VALA_PACKAGES gtk+-3.0 glib-2.0 posix gee-1.0)

vala_precompile(ICGTK_SRC ${ICGTK_SRC_VALA} PACKAGES ${ICGTK_VALA_PACKAGES} OPTIONS --thread CUSTOM_VAPIS ${CORELIB_VAPI})

add_executable(icCanvasGtk ${ICGTK_SRC})

target_link_libraries(icCanvasGtk ${GTK_LIBRARIES} gthread-2.0 m)
target_link_libraries(icCanvasGtk icCanvasManager)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")