cmake_minimum_required(VERSION 2.8)

include(${PARENT_PROJECT_DIR}/CMakeLists.txt)

file(GLOB CORELIB_SHRUGGED ${PARENT_PROJECT_DIR}/api/objc/src/*.m ${PARENT_PROJECT_DIR}/api/objc/src/*.mm)

include_directories(${CORELIB_INCLUDE_DIRS})
include_directories(${CAIRO_INCLUDE_DIRS})

add_library(icCanvasManager SHARED ${CORELIB} ${CORELIB_SHRUGGED})
set_target_properties(icCanvasManager PROPERTIES FRAMEWORK 1)

target_link_libraries(icCanvasManager ${CAIRO_LIBRARIES})
