cmake_minimum_required(VERSION 3.20)

project(testIntent DESCRIPTION "Tests compilers with intent(inout)" LANGUAGES Fortran)

set(CMAKE_VERBOSE_MAKEFILE ON)

add_executable(testIntent doSomething.F90 test.F90)

option(WITH_WARNINGS "Enable extra warnings" OFF)

if(WITH_WARNINGS)
    # Compilation fails if this is enabled with ifx
    target_compile_options(testIntent PRIVATE $<$<COMPILE_LANG_AND_ID:Fortran,IntelLLVM>:-warn all>)
    target_compile_options(testIntent PRIVATE $<$<COMPILE_LANG_AND_ID:Fortran,GNU>:-Wall -Wextra>)
endif()
