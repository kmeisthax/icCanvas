cmake_minimum_required(VERSION 2.8)

include(${PARENT_PROJECT_DIR}/CMakeLists.txt)

include_directories(${CORELIB_INCLUDE_DIRS})
include_directories(${CAIRO_INCLUDE_DIRS})

add_library(icCanvasManager SHARED ${CORELIB})

target_link_libraries(icCanvasManager ${CAIRO_LIBRARIES})