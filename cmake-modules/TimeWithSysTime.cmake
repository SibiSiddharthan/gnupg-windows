include(CheckCSourceCompiles)

check_c_source_compiles("
#include <sys/types.h>
#include <sys/time.h>
#include <time.h>

int
main ()
{
	if ((struct tm *) 0)
		return 0;
	return 0;
}"
TIME_WITH_SYS_TIME)
