cmake_minimum_required(VERSION 2.8)

project(icCanvas)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${PARENT_PROJECT_DIR}/modules")

find_package(Cairo)

if(!CAIRO_FOUND)
    message(FATAL_ERROR "Need Cairo to compile.")
endif()

file(GLOB CORELIB ${PARENT_PROJECT_DIR}/src/*.c ${PARENT_PROJECT_DIR}/src/*.cpp)
set(CORELIB_INCLUDE_DIRS ${PARENT_PROJECT_DIR}/include)