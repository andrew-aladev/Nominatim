add_executable(
    "nominatim"
    "export.c"
    "geometry.cpp"
    "import.c"
    "index.c"
    "input.c"
    "nominatim.c"
    "postgresql.c"
    "sprompt.c"
)

include(CheckIncludeFile)
CHECK_INCLUDE_FILE(byteswap.h HAVE_BYTESWAP_H)
CHECK_INCLUDE_FILE(sys/endian.h HAVE_SYS_ENDIAN_H)
if(HAVE_BYTESWAP_H)
  target_compile_definitions(nominatim PRIVATE HAVE_BYTESWAP_H)
endif(HAVE_BYTESWAP_H)
if(HAVE_SYS_ENDIAN_H)
  target_compile_definitions(nominatim PRIVATE HAVE_SYS_ENDIAN_H)
endif(HAVE_SYS_ENDIAN_H)

target_link_libraries(
  "nominatim"
  ${LIBXML2_LIBRARIES}
  ${ZLIB_LIBRARIES}
  ${BZIP2_LIBRARIES}
  ${PostgreSQL_LIBRARIES}
  ${CMAKE_THREAD_LIBS_INIT}
)

install(TARGETS "nominatim" DESTINATION ${CMAKE_INSTALL_BINDIR})
