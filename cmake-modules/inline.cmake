include_guard(GLOBAL)
include(UtilityFunctions)

set(inline_possibilities inline __inline__ __inline)
foreach(i ${inline_possibilities})

check_compile("Checking whether your compiler supports ${i}" "yes" "no" "
typedef int foo_t;
static ${i} foo_t static_foo () {return 0; }
${i} foo_t foo () {return 0; }
int main()
{
	return 0;
}"
INLINE_${i})

if(INLINE_inline)
	break() # we support the inline keyword, break the loop
endif()

if(INLINE_${i})
	set(inline ${i})
	break()
endif()

endforeach()

if(NOT DEFINED inline)
	set(inline /**/) # define inline to nothing
endif()
