if(${PORT} MATCHES "kfr")
  set(VCPKG_BUILD_TYPE release) # Case matters!
  # KFR builds and performs better with LLVM
  set(VCPKG_ENV_PASSTHROUGH_UNTRACKED "LLVMInstallDir;LLVMToolsVersion")
  set(VCPKG_CHAINLOAD_TOOLCHAIN_FILE
      "${CMAKE_CURRENT_LIST_DIR}/clang-toolchain.cmake")
endif()
