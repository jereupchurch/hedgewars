
#TESTING TIME
include(CheckCCompilerFlag)
#when you need to check for a linker flag, just leave the argument of "check_c_compiler_flag" empty


#check for noexecstack on ELF, Gentoo security
set(CMAKE_REQUIRED_FLAGS "-Wl,-z,noexecstack")
check_c_compiler_flag("" HAVE_NOEXECSTACK)
if(HAVE_NOEXECSTACK)
    list(APPEND pascal_flags "-k-z" "-knoexecstack")
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${CMAKE_REQUIRED_FLAGS}")
endif()

#check for ASLR on Windows Vista or later, requires binutils >= 2.20
set(CMAKE_REQUIRED_FLAGS "-Wl,--nxcompat")
check_c_compiler_flag("" HAVE_WINASLR)
if(HAVE_WINASLR)
    list(APPEND pascal_flags "-k--nxcompat")
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${CMAKE_REQUIRED_FLAGS}")
endif()

#check for DEP on Windows XP SP2 or later, requires binutils >= 2.20
set(CMAKE_REQUIRED_FLAGS "-Wl,--dynamicbase")
check_c_compiler_flag("" HAVE_WINDEP)
if(HAVE_WINDEP)
    list(APPEND pascal_flags "-k--dynamicbase")
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${CMAKE_REQUIRED_FLAGS}")
endif()


#always unset or these flags will be spread everywhere
unset(CMAKE_REQUIRED_FLAGS)

