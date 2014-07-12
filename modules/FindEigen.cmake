include (ExternalProject)

ExternalProject_Add(Eigen
    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/ext/eigen
    URL http://bitbucket.org/eigen/eigen/get/3.2.1.tar.gz)

#This hurts, but Eigen doesn't have a separate includes directory, so let's
#pollute the whole damn include namespace shall we?
set (EIGEN_INCLUDE_DIRS ${CMAKE_CURRENT_BINARY_DIR}/ext/eigen)
set (EIGEN_DEPS Eigen)