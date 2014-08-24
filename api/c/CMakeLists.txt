cmake_minimum_required(VERSION 2.8)

file(GLOB CORELIB_TORVALDS ${PARENT_PROJECT_DIR}/api/c/src/*.c ${PARENT_PROJECT_DIR}/api/c/src/*.cpp)

include_directories(${PARENT_PROJECT_DIR}/api/c/include)
include_directories(${CORELIB_INCLUDE_DIRS})
include_directories(${CAIRO_INCLUDE_DIRS})
include_directories(${EIGEN_INCLUDE_DIRS})

add_library(icCanvasManager SHARED ${CORELIB} ${CORELIB_TORVALDS})
target_link_libraries(icCanvasManager ${CAIRO_LIBRARIES})