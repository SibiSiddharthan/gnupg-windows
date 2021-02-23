include_guard(GLOBAL)
include(UtilityFunctions)

check_run("Checking endianess" "little endian" "big endian" "
int main ()
{
	/* Are we little or big endian?  From Harbison&Steele.  */
	union
	{
		long int l;
		char c[sizeof (long int)];
	} u;
	u.l = 1;
	return u.c[sizeof (long int) - 1] == 1;
}"
PLATFORM_LITTLEENDIAN)
if(PLATFORM_LITTLEENDIAN)
	set(WORDS_LITTLEENDIAN 1)
	set(LITTLE_ENDIAN_HOST 1)
else()
	set(WORDS_BIGENDIAN 1)
	set(BIG_ENDIAN_HOST 1)
endif()
