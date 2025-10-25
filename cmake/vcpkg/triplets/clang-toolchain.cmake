set(__VCPKG_ROOT_DIR ${VCPKG_ROOT_DIR})
if(NOT __VCPKG_ROOT_DIR)
  set(__VCPKG_ROOT_DIR ${Z_VCPKG_ROOT_DIR})
endif()
if(NOT __VCPKG_ROOT_DIR)
  set(__VCPKG_ROOT_DIR ${_VCPKG_ROOT_DIR})
endif()
if(NOT __VCPKG_ROOT_DIR)
  message(FATAL_ERROR "VCPKG_ROOT_DIR is not set")
endif()

if(UNIX)
  include(${__VCPKG_ROOT_DIR}/scripts/toolchains/linux.cmake)
  find_program(
    CLANG_CXX_COMPILER
    NAMES clang++-$ENV{LLVMToolsVersion}
    PATHS ENV LLVMInstallDir
    PATH_SUFFIXES "bin")
  find_program(
    CLANG_C_COMPILER
    NAMES clang-$ENV{LLVMToolsVersion}
    PATHS ENV LLVMInstallDir
    PATH_SUFFIXES "bin")
  find_program(
    CLANG_LINKER
    NAMES lld-$ENV{LLVMToolsVersion}
    PATHS ENV LLVMInstallDir
    PATH_SUFFIXES "bin")
  find_program(
    CLANG_AR
    NAMES llvm-ar-$ENV{LLVMToolsVersion}
    PATHS ENV LLVMInstallDir
    PATH_SUFFIXES "bin")
elseif(WIN32)
  include(${__VCPKG_ROOT_DIR}/scripts/toolchains/windows.cmake)
  find_program(
    CLANG_CXX_COMPILER
    NAMES clang-cl.exe
    PATHS ENV LLVMInstallDir
    PATH_SUFFIXES "bin")
  find_program(
    CLANG_C_COMPILER
    NAMES clang-cl.exe
    PATHS ENV LLVMInstallDir
    PATH_SUFFIXES "bin")
  find_program(
    CLANG_LINKER
    NAMES lld-link.exe
    PATHS ENV LLVMInstallDir
    PATH_SUFFIXES "bin")
  find_program(
    CLANG_AR
    NAMES llvm-lib.exe
    PATHS ENV LLVMInstallDir
    PATH_SUFFIXES "bin")
  find_program(
    CLANG_MT
    NAMES llvm-mt.exe
    PATHS ENV LLVMInstallDir
    PATH_SUFFIXES "bin")
  find_program(
    CLANG_RC_COMPILER
    NAMES llvm-rc.exe
    PATHS ENV LLVMInstallDir
    PATH_SUFFIXES "bin")
endif()

set(CMAKE_CXX_COMPILER ${CLANG_CXX_COMPILER})
set(CMAKE_C_COMPILER ${CLANG_C_COMPILER})
set(CMAKE_LINKER ${CLANG_LINKER})
set(CMAKE_AR ${CLANG_AR})
if(WIN32)
  set(CMAKE_MT ${CLANG_MT})
  set(CMAKE_RC_COMPILER ${CLANG_RC_COMPILER})
endif()
