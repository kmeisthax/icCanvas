cmake_minimum_required(VERSION 2.8)

project(icCanvas)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/modules")

find_package(Cairo)

if(!CAIRO_FOUND)
    message(FATAL_ERROR "Need Cairo to compile.")
endif()

if(CMAKE_COMPILER_IS_GNUCXX)
    add_definitions(-std=c++11)
endif()

file(GLOB CORELIB ../src/*.c ../src/*.cpp)
include_directories(../include)
include_directories(${CAIRO_INCLUDE_DIRS})

add_library(icCanvasManager SHARED ${CORELIB})

target_link_libraries(icCanvasManager ${CAIRO_LIBRARIES})