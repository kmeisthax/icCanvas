cmake_minimum_required(VERSION 2.8)

set(PARENT_PROJECT_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../..")
include(${PARENT_PROJECT_DIR}/CMakeLists.txt)

find_library(APPKIT AppKit)

file(GLOB ICAPPKIT_SRC src/*.m)
include_directories(include)

add_executable(icCanvas MACOSX_BUNDLE ${ICAPPKIT_SRC})
target_link_libraries(icCanvas ${APPKIT})