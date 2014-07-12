include (ExternalProject)

ExternalProject_Add(Eigen
    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/ext/eigen
    URL http://bitbucket.org/eigen/eigen/get/3.2.1.tar.gz
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND "")

#This hurts, but Eigen doesn't have a separate includes directory, so let's
#pollute the whole damn include namespace shall we?
set (EIGEN_INCLUDE_DIRS ${CMAKE_CURRENT_BINARY_DIR}/ext/eigen/src/Eigen)
set (EIGEN_DEPS Eigen)