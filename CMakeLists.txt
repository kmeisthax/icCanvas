cmake_minimum_required(VERSION 2.8)

project(icCanvas)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${PARENT_PROJECT_DIR}/modules")

find_package(Cairo)

if(!CAIRO_FOUND)
    message(FATAL_ERROR "Need Cairo to compile.")
endif()

if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
    set(CMAKE_CXX_FLAGS "-std=c++11 -stdlib=libc++")
elseif (CMAKE_COMPILER_IS_GNUCXX)
    add_definitions(-std=c++11)
elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Intel")
    message("Hope you like your code running slow on AMD")
endif()

file(GLOB CORELIB ${PARENT_PROJECT_DIR}/src/*.c ${PARENT_PROJECT_DIR}/src/*.cpp)
set(CORELIB_INCLUDE_DIRS ${PARENT_PROJECT_DIR}/include)