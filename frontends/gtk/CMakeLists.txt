cmake_minimum_required(VERSION 2.8)

set(PARENT_PROJECT_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../..")
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${PARENT_PROJECT_DIR}/modules")

find_package(VALA REQUIRED)

include(${PARENT_PROJECT_DIR}/CMakeLists.txt)
include(${PARENT_PROJECT_DIR}/api/c/CMakeLists.txt)
include(${PARENT_PROJECT_DIR}/api/vala/CMakeLists.txt)

find_package(Eigen)
find_package(Cairo)

if(!CAIRO_FOUND)
    message(FATAL_ERROR "Need Cairo to compile.")
endif()

include(${PARENT_PROJECT_DIR}/api/cpp/CMakeLists.txt)

find_package(PkgConfig)
pkg_check_modules(GTK gtk+-3.0)

link_directories(${GTK_LIBRARY_DIRS})
include_directories(${GTK_INCLUDE_DIRS})

file(GLOB ICGTK_SRC_VALA src/*.vala)
include_directories(include)

set(ICGTK_VALA_PACKAGES gtk+-3.0)

vala_precompile(ICGTK_SRC ${ICGTK_SRC_VALA} PACKAGES ${ICGTK_VALA_PACKAGES} OPTIONS --thread CUSTOM_VAPIS ${CORELIB_VAPI})

add_executable(icCanvasGtk ${ICGTK_SRC})

target_link_libraries(icCanvasGtk ${GTK_LIBRARIES})
target_link_libraries(icCanvasGtk icCanvasManager)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")