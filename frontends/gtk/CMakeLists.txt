cmake_minimum_required(VERSION 2.8)

set(PARENT_PROJECT_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../..")

include(${PARENT_PROJECT_DIR}/CMakeLists.txt)

find_package(Cairo)

if(!CAIRO_FOUND)
    message(FATAL_ERROR "Need Cairo to compile.")
endif()

include(${PARENT_PROJECT_DIR}/api/cpp/CMakeLists.txt)

find_package(PkgConfig)
pkg_check_modules(GTKMM gtkmm-3.0)

link_directories(${GTKMM_LIBRARY_DIRS})
include_directories(${GTKMM_INCLUDE_DIRS})

file(GLOB ICGTK_SRC src/*.cpp)
include_directories(include)

add_executable(icCanvasGtk ${ICGTK_SRC})

target_link_libraries(icCanvasGtk ${GTKMM_LIBRARIES})

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")