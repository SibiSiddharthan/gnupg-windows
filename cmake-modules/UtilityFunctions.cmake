#[[
   Copyright (c) 2021 Sibi Siddharthan

   Distributed under the MIT license.
   Refer to the LICENSE file at the root directory for details.
]]

include_guard(GLOBAL)

include(CheckTypeSize)
include(CheckIncludeFile)
include(CheckIncludeFileCXX)
include(CheckSymbolExists)
include(CheckFunctionExists)
include(CheckCSourceCompiles)
include(CheckCSourceRuns)
include(CheckStructHasMember)

#true
set(STDC_HEADERS 1)

function(check_c_headers ...)
	math(EXPR STOP "${ARGC} -1")
	foreach(i RANGE ${STOP})
		set(var ${ARGV${i}})
		string(REPLACE "/" "_" var ${var})
		string(REPLACE "." "_" var ${var})
		string(TOUPPER ${var} var)
		string(PREPEND var "HAVE_")
		check_include_file(${ARGV${i}} ${var})
		if(NOT ${var})
			set(${var} 0 PARENT_SCOPE)
		endif()
	endforeach()
endfunction()

function(check_cxx_headers ...)
	math(EXPR STOP "${ARGC} -1")
	foreach(i RANGE ${STOP})
		set(var ${ARGV${i}})
		string(REPLACE "/" "_" var ${var})
		string(REPLACE "." "_" var ${var})
		string(TOUPPER ${var} var)
		string(PREPEND var "HAVE_")
		check_include_file_cxx(${ARGV${i}} ${var})
		if(NOT ${var})
			set(${var} 0 PARENT_SCOPE)
		endif()
	endforeach()
endfunction()

function(check_functions ...) 
	math(EXPR STOP "${ARGC} -1")
	foreach(i RANGE ${STOP})
		set(var ${ARGV${i}})
		string(TOUPPER ${var} var)
		string(PREPEND var "HAVE_")
		check_function_exists(${ARGV${i}} ${var})
		if(NOT ${var})
			set(${var} 0 PARENT_SCOPE)
		endif()
	endforeach()
endfunction()

check_c_headers(stdio.h sys/types.h sys/stat.h stdlib.h stddef.h stdlib.h string.h strings.h inttypes.h stdint.h unistd.h math.h)
list(APPEND c_include stdio.h)
if(HAVE_SYS_TYPES_H)
	list(APPEND c_include sys/types.h)
endif()
if(HAVE_SYS_STAT_H)
	list(APPEND c_include sys/stat.h)
endif()
if(HAVE_STDLIB_H)
	list(APPEND c_include stdlib.h)
endif()
if(HAVE_STDDEF_H)
	list(APPEND c_include stddef.h)
endif()
if(HAVE_STRING_H)
	list(APPEND c_include string.h)
endif()
if(HAVE_STRINGS_H)
	list(APPEND c_include strings.h)
endif()
if(HAVE_INTTYPES_H)
	list(APPEND c_include inttypes.h)
endif()
if(HAVE_STDINT_H)
	list(APPEND c_include stdint.h)
endif()
if(HAVE_UNISTD_H)
	list(APPEND c_include unistd.h)
endif()
if(HAVE_MATH_H)
	list(APPEND c_include math.h)
endif()


set(c_default_includes
"
#include <stdio.h>
#if ${HAVE_SYS_TYPES_H}
# include <sys/types.h>
#endif
#if ${HAVE_SYS_STAT_H}
# include <sys/stat.h>
#endif
#if ${STDC_HEADERS}
# include <stdlib.h>
# include <stddef.h>
#else
# ifdef ${HAVE_STDLIB_H}
#  include <stdlib.h>
# endif
#endif
#if ${HAVE_STRING_H}
# include <string.h>
#endif
#if ${HAVE_STRINGS_H}
# include <strings.h>
#endif
#if ${HAVE_INTTYPES_H}
# include <inttypes.h>
#endif
#if ${HAVE_STDINT_H}
# include <stdint.h>
#endif
#if ${HAVE_UNISTD_H}
# include <unistd.h>
#endif
")



function(check_function_declarations ...)
	math(EXPR STOP "${ARGC} -1")
	foreach(i RANGE ${STOP})
		set(var ${ARGV${i}})
		string(TOUPPER ${var} var)
		string(PREPEND var "HAVE_DECL_")
		check_symbol_exists(${ARGV${i}} "${CMAKE_EXTRA_INCLUDE_FILES};${c_include}" ${var})
		if(NOT ${var})
			set(${var} 0 PARENT_SCOPE)
		endif()
	endforeach()
endfunction()

function(check_types ...)
	math(EXPR STOP "${ARGC} -1")
	set(CMAKE_EXTRA_INCLUDE_FILES "${CMAKE_EXTRA_INCLUDE_FILES};${c_include}")
	foreach(i RANGE ${STOP})
		set(var ${ARGV${i}})
		string(REPLACE " " "_" var ${var})
		string(REPLACE "*" "P" var ${var})
		string(TOUPPER ${var} var)
		set(have_var ${var})
		string(PREPEND have_var "HAVE_")
		string(PREPEND var "SIZEOF_")

		if(NOT DEFINED ${var})
			message(CHECK_START "Checking size of ${ARGV${i}}")
			set(CMAKE_REQUIRED_QUIET 1)
			check_type_size(${ARGV${i}} ${var})
			unset(CMAKE_REQUIRED_QUIET)
			if(${var})
				message(CHECK_PASS "${${var}} bytes")
			else()
				message(CHECK_FAIL "failed")
			endif()
		endif()
		if(${var})
			set(${have_var} 1 PARENT_SCOPE)
		else()
			set(${have_var} 0 PARENT_SCOPE)
		endif()
	endforeach()
	unset(CMAKE_EXTRA_INCLUDE_FILES)
endfunction()

function(check_compile description success fail source var)
	if(NOT DEFINED ${var})
		set(CMAKE_REQUIRED_QUIET 1)
		message(CHECK_START ${description})
		string(REPLACE "\\" "\\\\" escaped_source "${source}")
		check_c_source_compiles("${escaped_source}" ${var})
		if(${var})
			message(CHECK_PASS ${success})
		else()
			message(CHECK_FAIL ${fail})
		endif()
		unset(CMAKE_REQUIRED_QUIET)
	endif()
endfunction()

function(check_run description success fail source var)
	if(NOT DEFINED ${var})
		set(CMAKE_REQUIRED_QUIET 1)
		message(CHECK_START ${description})
		string(REPLACE "\\" "\\\\" escaped_source "${source}")
		check_c_source_runs("${escaped_source}" ${var})
		if(${var})
			message(CHECK_PASS ${success})
		else()
			message(CHECK_FAIL ${fail})
		endif()
		unset(CMAKE_REQUIRED_QUIET)
	endif()
endfunction()

function(check_struct struct member includes var)
	if(NOT DEFINED ${var})
		set(CMAKE_REQUIRED_QUIET 1)
		message(CHECK_START "Checking whether ${member} is a member of ${struct}")
		check_struct_has_member("${struct}" "${member}" "${includes}" ${var})
		if(${var})
			message(CHECK_PASS "yes")
		else()
			message(CHECK_FAIL "no")
		endif()
		unset(CMAKE_REQUIRED_QUIET)
	endif()
endfunction()
