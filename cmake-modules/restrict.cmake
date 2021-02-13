include(CheckCSourceCompiles)

set(restrict_possibblities __restrict __restrict__ _Restrict restrict)
foreach(r ${restrict_possibblities})
  check_c_source_compiles("
  typedef int *int_ptr;
  int foo (int_ptr ${r} ip) { return ip[0]; }
  int bar (int [${r}]); /* Catch GCC bug 14050.  */
  int bar (int ip[${r}]) { return ip[0]; }

int
main ()
{
  int s[1];
  int *${r} t = s;
  t[0] = 0;
  return foo (t) + bar (t);
  return 0;
}"
RESTRICT_${r})
if(RESTRICT_${r})
  set(restrict ${r})
  break()
endif()
endforeach()

if(NOT DEFINED restrict)
set(restrict /**/)
endif()
