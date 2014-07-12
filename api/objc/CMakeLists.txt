cmake_minimum_required(VERSION 2.8)

file(GLOB CORELIB_SHRUGGED ${PARENT_PROJECT_DIR}/api/objc/src/*.m ${PARENT_PROJECT_DIR}/api/objc/src/*.mm)

include_directories(${PARENT_PROJECT_DIR}/api/objc/include)
include_directories(${CORELIB_INCLUDE_DIRS})
include_directories(${CAIRO_INCLUDE_DIRS})
include_directories(${EIGEN_INCLUDE_DIRS})

add_library(icCanvasManager SHARED ${CORELIB} ${CORELIB_SHRUGGED})
set_target_properties(icCanvasManager PROPERTIES FRAMEWORK 1)

target_link_libraries(icCanvasManager ${CAIRO_LIBRARIES})

if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
    set_target_properties(icCanvasManager PROPERTIES COMPILE_FLAGS "-std=c++11 -stdlib=libc++")
    set_source_files_properties(${CORELIB_SHRUGGED} PROPERTIES COMPILE_FLAGS "-std=c++11 -stdlib=libc++ -fobjc-arc")
elseif (CMAKE_COMPILER_IS_GNUCXX)
    set_target_properties(icCanvasManager PROPERTIES COMPILE_FLAGS "-std=c++11 -stdlib=libc++")
elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Intel")
    message("Hope you like your code running slow on AMD")
endif()