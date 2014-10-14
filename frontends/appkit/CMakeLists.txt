cmake_minimum_required(VERSION 2.8)

set(PARENT_PROJECT_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../..")
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${PARENT_PROJECT_DIR}/modules")

find_package(Eigen)
include(${PARENT_PROJECT_DIR}/modules/BuildCairo.cmake)
include(${PARENT_PROJECT_DIR}/CMakeLists.txt)
include(${PARENT_PROJECT_DIR}/api/objc/CMakeLists.txt)

find_library(APPKIT AppKit)
find_library(QUARTZCORE QuartzCore)

file(GLOB ICAPPKIT_SRC src/*.m)
include_directories(include)

add_executable(icCanvas MACOSX_BUNDLE ${ICAPPKIT_SRC})
target_link_libraries(icCanvas ${APPKIT})
target_link_libraries(icCanvas icCanvasManager)

target_link_libraries(icCanvasManager ${APPKIT} ${QUARTZCORE})

if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
    set_target_properties(icCanvas PROPERTIES COMPILE_FLAGS "-fobjc-arc")
elseif (CMAKE_COMPILER_IS_GNUCXX)
    message("The RMS is pleased.")
elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Intel")
    message("You're kidding, right?!")
endif()

set(ICCANVAS_APP "\${CMAKE_INSTALL_PREFIX}/icCanvas.app")
set(CORELIB_BUNDLE "\${CMAKE_INSTALL_PREFIX}/icCanvasManager.framework")

set_target_properties(icCanvas PROPERTIES MACOSX_BUNDLE_INFO_PLIST "${CMAKE_CURRENT_SOURCE_DIR}/resources/Info.plist")

install(TARGETS icCanvas BUNDLE DESTINATION .)
install(CODE "
    include(BundleUtilities)
    fixup_bundle(\"${ICCANVAS_APP}\" \"\" \"\")
    ")

set(CPACK_GENERATOR DragNDrop)

include(CPack)