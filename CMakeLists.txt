cmake_minimum_required(VERSION 2.8)

project(icCanvas)

find_package(Eigen)

file(GLOB CORELIB ${PARENT_PROJECT_DIR}/src/*.c ${PARENT_PROJECT_DIR}/src/*.cpp)
set(CORELIB_INCLUDE_DIRS ${PARENT_PROJECT_DIR}/include ${EIGEN_INCLUDE_DIRS})