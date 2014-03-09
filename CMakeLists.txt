cmake_minimum_required(VERSION 2.8)

project(icCanvas)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${PARENT_PROJECT_DIR}/modules")

find_package(Cairo)

if(!CAIRO_FOUND)
    message(FATAL_ERROR "Need Cairo to compile.")
endif()

if(CMAKE_COMPILER_IS_GNUCXX)
    add_definitions(-std=c++11)
endif()

file(GLOB CORELIB ${PARENT_PROJECT_DIR}/src/*.c ${PARENT_PROJECT_DIR}/src/*.cpp)
include_directories(${PARENT_PROJECT_DIR}/include)
include_directories(${CAIRO_INCLUDE_DIRS})

add_library(icCanvasManager SHARED ${CORELIB})

target_link_libraries(icCanvasManager ${CAIRO_LIBRARIES})