include(CheckCSourceCompiles)

set(inline_possibblities inline __inline__ __inline)
foreach(i ${inline_possibblities})
  check_c_source_compiles("
typedef int foo_t;
static ${i} foo_t static_foo () {return 0; }
${i} foo_t foo () {return 0; }
int main(){return 0;}"
INLINE_${i})
if(INLINE_${i})
  set(HAVE_INLINE 1)
  string(TOUPPER ${i} ui)
  set(HAVE_${ui} 1)
endif()
endforeach()
