include_guard(GLOBAL)
include(UtilityFunctions)

check_compile("Checking whether off_t is 64 bits for supporting large files" "yes" "no" "
#ifdef _FILE_OFFSET_BITS
# undef _FILE_OFFSET_BITS
#endif
#define _FILE_OFFSET_BITS 64
#include <sys/types.h>
/* Check that off_t can represent 2**63 - 1 correctly.
   We can't simply define LARGE_OFF_T to be 9223372036854775807,
   since some C++ compilers masquerading as C compilers
   incorrectly reject 9223372036854775807.  */
#define LARGE_OFF_T (((off_t) 1 << 62) - 1 + ((off_t) 1 << 62))
int off_t_is_large[(LARGE_OFF_T % 2147483629 == 721
	&& LARGE_OFF_T % 2147483647 == 1) ? 1 : -1];

int main ()
{
	return 0;
}"
_FILE_OFFSET_BITS)
if(_FILE_OFFSET_BITS)
	set(_FILE_OFFSET_BITS 64)
	set(__LARGE_FILES 1)
endif()
