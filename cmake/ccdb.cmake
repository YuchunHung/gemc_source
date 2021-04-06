#
#  CCDB does not have a decent CMakeLists.txt -- this ought to be fixed.
#  None of the versions that are on GIT actually build correctly either if you use scons and Python 3
#  This means it needs a custom build script here
#
#
message(STATUS "Checking for ccdb")
find_package(ccdb QUIET)
if(NOT ccdb_FOUND)
    message(STATUS "********************* ccdb was not found ***************************")
    message(STATUS "* We will get ccdb from GitHub and install it.                     *")
    message(STATUS "* If this is not what you want, make sure ccdb can be found        *")
    message(STATUS "* set CMAKE_PREFIX_PATH to include the ccdbConfig.cmake file       *")
    message(STATUS "********************* CCDB was not found ***************************")
    set(CCDB_VERSION cmake_v1.07 CACHE STRING "ccdb version" FORCE)
    externalproject_add(
            ccdb_external
            GIT_REPOSITORY   "https://github.com/mholtrop/ccdb"
            GIT_TAG          ${CCDB_VERSION}
            SOURCE_DIR       ${CMAKE_BINARY_DIR}/ccdb
            INSTALL_DIR      ${CMAKE_INSTALL_PREFIX}
            CMAKE_ARGS       -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
            BUILD_COMMAND    ${CMAKE_MAKE_PROGRAM} -j8
            UPDATE_COMMAND   ""
    )
    # Make (empty) include directories fir ccdb. These will be filled during "make"
    file(MAKE_DIRECTORY ${CMAKE_INSTALL_PREFIX}/include/ccdb)
    file(MAKE_DIRECTORY ${CMAKE_INSTALL_PREFIX}/include/ccdb/CCDB)

    # Add the actual libraries
    add_library(ccdb_sqlite STATIC IMPORTED)
    add_library(ccdb STATIC IMPORTED)
    set_target_properties(ccdb_sqlite PROPERTIES
                          IMPORTED_LOCATION "${CMAKE_BINARY_DIR}/ccdb"
                          IMPORTED_CONFIGURATIONS RELEASE
                          INTERFACE_INCLUDE_DIRECTORIES "${CMAKE_INSTALL_PREFIX}/include/ccdb"
                          )
    set_target_properties(ccdb PROPERTIES
                          IMPORTED_LOCATION "${CMAKE_BINARY_DIR}/ccdb"
                          IMPORTED_CONFIGURATIONS RELEASE
                          INTERFACE_INCLUDE_DIRECTORIES "${CMAKE_INSTALL_PREFIX}/include/ccdb;${CMAKE_INSTALL_PREFIX}/include/ccdb/CCDB"
                          INTERFACE_LINK_LIBRARIES "/usr/local/mysql/lib/libmysqlclient.dylib;ccdb_sqlite"
                          )
#    target_include_directories(ccdb  INTERFACE
#                               ${CMAKE_INSTALL_PREFIX}/include/ccdb
#                               ${CMAKE_INSTALL_PREFIX}/include/ccdb/CCDB
#                               )
#    target_link_libraries(ccdb INTERFACE
#                          ${CMAKE_INSTALL_PREFIX}/lib/libccdb_sqlite.a)
    set_property(TARGET ccdb_sqlite APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
    set_target_properties(ccdb_sqlite PROPERTIES
                          IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "C"
                          IMPORTED_LOCATION_RELEASE "${CMAKE_INSTALL_PREFIX}/lib/libccdb_sqlite.a"
                          )
    set_property(TARGET ccdb APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
    set_target_properties(ccdb PROPERTIES
                          IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "CXX"
                          IMPORTED_LOCATION_RELEASE "${CMAKE_INSTALL_PREFIX}/lib/libccdb.a"
                          )


    # Setup dependencies.
    add_dependencies(dependencies ccdb)
    add_dependencies(ccdb ccdb_external)

endif()
include($ENV{HOME}/cmake/cmake_debug_properties.cmake)
print_target_properties(ccdb)
