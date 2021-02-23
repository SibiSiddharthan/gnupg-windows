include_guard(GLOBAL)
include(UtilityFunctions)

check_include_file(sys/time.h HAVE_SYS_TIME_H)
if(HAVE_SYS_TIME_H)

message(CHECK_START "Checking whether sys/time.h can be included with time.h")
check_compile("Checking whether sys/time.h can be included with time.h" "yes" "no" "
#include <sys/types.h>
#include <sys/time.h>
#include <time.h>

int main ()
{
	if ((struct tm *) 0)
		return 0;
	return 0;
}"
TIME_WITH_SYS_TIME)

if(NOT TIME_WITH_SYS_TIME)
	set(TIME_WITH_SYS_TIME 0)
endif()

endif()
