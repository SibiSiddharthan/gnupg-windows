#[[
   Copyright (c) 2021 Sibi Siddharthan

   Distributed under the MIT license.
   Refer to the LICENSE file at the root directory for details.
]]

cmake_minimum_required(VERSION 3.12)
project(GnuPG)

set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake-modules)
include(UtilityFunctions)
include(CTest)

option(BUILD_DOCS "Build documentation" ON)
find_program(INFO_EXE info)
if(NOT INFO_EXE)
	set(BUILD_DOCS OFF)
endif()

if(WIN32)
	add_compile_definitions(_CRT_SECURE_NO_WARNINGS
							_CRT_NONSTDC_NO_DEPRECATE
							_WINSOCK_DEPRECATED_NO_WARNINGS)
endif()

if(CMAKE_C_COMPILER_ID STREQUAL "Clang")
	add_compile_options(-Wall
						-Wno-int-to-void-pointer-cast
						-Wno-pointer-sign
						-Wno-unused-variable
						-Wno-unused-function
						-Wno-int-conversion
						-Wno-microsoft-enum-forward-reference
						-Wno-switch
						-fcolor-diagnostics -fansi-escape-codes)
elseif(CMAKE_C_COMPILER_ID STREQUAL "GNU")
	add_compile_options(-Wall
						-Wno-pointer-sign
						-Wno-unused-result
						-Wno-unused-but-set-variable
						-Wno-unused-variable
						-Wno-int-conversion
						-Wno-format-zero-length
						-fdiagnostics-color)
elseif(CMAKE_C_COMPILER_ID STREQUAL "MSVC")
	add_compile_options(/wd4311 #-Wno-int-to-void-pointer-cast
						/wd4312 #-Wno-int-to-void-pointer-cast
						/wd4267 # conversion from size_t to smaller type
						/wd4018 # signed and unsigned compare
						/wd4047 #-Wno-int-conversion
						/wd4133 # incompatible pointer types
						/wd4101 #-Wno-unused-variable
						/wd4244 # possible loss of data
						/wd4090 # Incompatible const qualifiers
						/wd4146 # unary minus operator applied to unsigned type
						/wd4334 # left shift type promotion
						/wd4229 # modifiers on data ignored
						)
endif()

include_directories(${CMAKE_BINARY_DIR})

string(REPLACE ";" "\;" NEW_PATH "$ENV{PATH}")
macro(set_dll_output_directory dll_target directory)
	set_target_properties(${dll_target} PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${directory})
	get_property(MY_GENERATOR_IS_MULTI_CONFIG GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)
	if(MY_GENERATOR_IS_MULTI_CONFIG)
		foreach(config ${CMAKE_CONFIGURATION_TYPES})
			string(TOUPPER ${config} config)
			set_target_properties(${dll_target} PROPERTIES RUNTIME_OUTPUT_DIRECTORY_${config} ${directory})
		endforeach()
	endif()
endmacro()

if(WIN32)
	configure_file(unistd.h.in unistd.h)
	set(HAVE_UNISTD_H 1)
endif()

add_subdirectory(libgpg-error)
add_subdirectory(npth)
add_subdirectory(libksba)
add_subdirectory(libassuan)
add_subdirectory(libgcrypt)
add_subdirectory(gnupg)
add_subdirectory(pinentry)
