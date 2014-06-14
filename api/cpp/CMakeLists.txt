cmake_minimum_required(VERSION 2.8)

include_directories(${CORELIB_INCLUDE_DIRS})
include_directories(${CAIRO_INCLUDE_DIRS})

add_library(icCanvasManager SHARED ${CORELIB})

target_link_libraries(icCanvasManager ${CAIRO_LIBRARIES})

if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
    set_target_properties(icCanvasManager PROPERTIES COMPILE_FLAGS "-std=c++11")
elseif (CMAKE_COMPILER_IS_GNUCXX)
    set_target_properties(icCanvasManager PROPERTIES COMPILE_FLAGS "-std=c++11")
elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Intel")
    message("Hope you like your code running slow on AMD")
endif()