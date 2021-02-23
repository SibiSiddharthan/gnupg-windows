include_guard(GLOBAL)
include(UtilityFunctions)

check_compile("Checking return type of signal handlers" "int" "void" "
#include <sys/types.h>
#include <signal.h>

int main ()
{
	return *(signal (0, 0)) (0) == 1;
}"
RETSIGTYPE)
if(RETSIGTYPE)
	set(RETSIGTYPE int)
else()
	set(RETSIGTYPE void)
endif()
