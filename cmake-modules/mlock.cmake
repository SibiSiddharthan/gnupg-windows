include_guard(GLOBAL)
include(UtilityFunctions)

check_function_exists(mlock HAVE_MLOCK)

if(HAVE_MLOCK)
check_run("Checking whether mlock is broken" "no" "yes" "
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <fcntl.h>

int main()
{
	char *pool;
	int err;
	long int pgsize;

#if ${HAVE_SYSCONF} && defined(_SC_PAGESIZE)
	pgsize = sysconf (_SC_PAGESIZE);
#elif  ${HAVE_GETPAGESIZE}
	pgsize = getpagesize();
#else
	pgsize = -1;
#endif

	if (pgsize == -1)
		pgsize = 4096;

	pool = malloc( 4096 + pgsize );
	if( !pool )
		return 2;
	pool += (pgsize - ((long int)pool % pgsize));

	err = mlock( pool, 4096 );
	if( !err || errno == EPERM || errno == EAGAIN)
		return 0; /* okay */

	return 1;  /* hmmm */
}"
MLOCK_OKAY)
if(NOT MLOCK_OKAY)
	set(HAVE_BROKEN_MLOCK 1)
endif()
endif()
