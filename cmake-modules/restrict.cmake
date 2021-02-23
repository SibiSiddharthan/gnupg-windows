include_guard(GLOBAL)
include(UtilityFunctions)

set(restrict_possibilities restrict __restrict __restrict__ _Restrict)
foreach(r ${restrict_possibilities})

check_compile("Checking whether your compiler supports ${r}" "yes" "no" "
typedef int *int_ptr;
int foo (int_ptr ${r} ip) { return ip[0]; }
int bar (int [${r}]); /* Catch GCC bug 14050.  */
int bar (int ip[${r}]) { return ip[0]; }

int main ()
{
	int s[1];
	int *${r} t = s;
	t[0] = 0;
	return foo (t) + bar (t);
	return 0;
}"
RESTRICT_${r})

if(RESTRICT_restrict)
	break() # we support the restrict keyword, break the loop
endif()

if(RESTRICT_${r})
  set(restrict ${r})
  break()
endif()

endforeach()

if(NOT DEFINED restrict)
  set(restrict /**/)
endif()
