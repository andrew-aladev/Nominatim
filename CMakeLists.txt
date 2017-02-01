#-----------------------------------------------------------------------------
#
#  CMake Config
#
#  Nominatim
#
#-----------------------------------------------------------------------------

cmake_minimum_required(VERSION 2.8 FATAL_ERROR)
list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")


#-----------------------------------------------------------------------------
#
#  Project version
#
#-----------------------------------------------------------------------------

project("nominatim")

set(NOMINATIM_VERSION_MAJOR 2)
set(NOMINATIM_VERSION_MINOR 5)

set(NOMINATIM_VERSION "${NOMINATIM_VERSION_MAJOR}.${NOMINATIM_VERSION_MINOR}")

add_definitions(-DNOMINATIM_VERSION="${NOMINATIM_VERSION}")

if (NOT DEFINED CMAKE_INSTALL_BINDIR)
    set (CMAKE_INSTALL_BINDIR "bin" CACHE PATH "Output directory for binaries")
endif ()
if (NOT DEFINED CMAKE_INSTALL_LIBDIR)
    set (CMAKE_INSTALL_LIBDIR "lib" CACHE PATH "Output directory for libraries")
endif ()
if (NOT DEFINED CMAKE_INSTALL_WWWDIR)
    set (CMAKE_INSTALL_WWWDIR "share/nominatim" CACHE PATH "Output directory for website data")
endif ()
if (NOT DEFINED CMAKE_INSTALL_DOCDIR)
    set (CMAKE_INSTALL_DOCDIR "share/doc" CACHE PATH "Output directory for docs")
endif ()


#-----------------------------------------------------------------------------
#
#  Find external dependencies
#
#-----------------------------------------------------------------------------

option(BUILD_DEPLOY "Build utils for website deployment")
option(BUILD_TESTS "Build test suite" OFF)
option(BUILD_DOC "Build docs" OFF)
option(EXTERNAL_OSM2PGSQL "Do not use osm2pgsql from git submodule" OFF)

if (NOT BUILD_DEPLOY OR NOT EXTERNAL_OSM2PGSQL)
  add_subdirectory("osm2pgsql")
endif()

find_package(Threads REQUIRED)

unset(PostgreSQL_TYPE_INCLUDE_DIR CACHE)
set(PostgreSQL_TYPE_INCLUDE_DIR "/usr/include/")
find_package(PostgreSQL REQUIRED)
include_directories("${PostgreSQL_INCLUDE_DIRS}")

find_program(PG_CONFIG "pg_config")
execute_process(
    COMMAND ${PG_CONFIG} "--pgxs"
    OUTPUT_VARIABLE PGXS
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

if (NOT EXISTS ${PGXS})
    message(FATAL_ERROR "Postgresql server package not found.")
endif()

find_package(ZLIB REQUIRED)

find_package(BZip2 REQUIRED)

find_package(LibXml2 REQUIRED)
include_directories("${LIBXML2_INCLUDE_DIR}")

#-----------------------------------------------------------------------------
#
# Setup settings and paths
#
#-----------------------------------------------------------------------------

set(
    CUSTOMFILES
    "settings/phrase_settings.php"
    "website/deletable.php"
    "website/details.php"
    "website/hierarchy.php"
    "website/lookup.php"
    "website/polygons.php"
    "website/reverse.php"
    "website/search.php"
    "website/status.php"
    "utils/blocks.php"
    "utils/country_languages.php"
    "utils/imports.php"
    "utils/importWikipedia.php"
    "utils/query.php"
    "utils/server_compare.php"
    "utils/setup.php"
    "utils/specialphrases.php"
    "utils/update.php"
    "utils/warm.php"
)

foreach (cfile ${CUSTOMFILES})
    configure_file("${PROJECT_SOURCE_DIR}/${cfile}" "${PROJECT_BINARY_DIR}/${cfile}")
endforeach()

configure_file("${PROJECT_SOURCE_DIR}/settings/defaults.php" "${PROJECT_BINARY_DIR}/settings/settings.php")

set(WEBPATHS "css" "images" "js")
foreach (wp ${WEBPATHS})
    execute_process(
        COMMAND "cp" "-R" "${PROJECT_SOURCE_DIR}/website/${wp}" "${PROJECT_BINARY_DIR}/website/"
    )
endforeach()


#-----------------------------------------------------------------------------
#
# Tests
#
#-----------------------------------------------------------------------------

if (BUILD_TESTS)
    include(CTest)

    add_test(
        NAME "php"
        COMMAND "phpunit" "../"
        WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}/test/php"
    )
    add_test(
        NAME "behave"
        COMMAND "behave"
        WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}/test/bdd"
    )
endif()

#-----------------------------------------------------------------------------

add_subdirectory("module")
add_subdirectory("nominatim")

if (BUILD_DOC)
    add_subdirectory("docs")
endif()

#-----------------------------------------------------------------------------
#
# Installation
#
#-----------------------------------------------------------------------------

install(DIRECTORY "lib"     DESTINATION ${CMAKE_INSTALL_WWWDIR})
install(DIRECTORY "website" DESTINATION ${CMAKE_INSTALL_WWWDIR})
install(DIRECTORY "utils"   DESTINATION ${CMAKE_INSTALL_WWWDIR})
install(DIRECTORY "data"    DESTINATION ${CMAKE_INSTALL_WWWDIR})
install(DIRECTORY "sql"     DESTINATION ${CMAKE_INSTALL_WWWDIR})

install(DIRECTORY "${PROJECT_BINARY_DIR}/settings" DESTINATION ${CMAKE_INSTALL_WWWDIR})

install(FILES "${CMAKE_CURRENT_BINARY_DIR}/module/nominatim.so" DESTINATION ${CMAKE_INSTALL_WWWDIR}/module)
