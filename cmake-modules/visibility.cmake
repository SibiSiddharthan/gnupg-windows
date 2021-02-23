include_guard(GLOBAL)
include(UtilityFunctions)

check_compile("Checking whether the visibility attribute is supported" "yes" "no" "
extern __attribute__((__visibility__(\"hidden\"))) int hiddenvar;
extern __attribute__((__visibility__(\"default\"))) int exportedvar;
extern __attribute__((__visibility__(\"hidden\"))) int hiddenfunc (void);
extern __attribute__((__visibility__(\"default\"))) int exportedfunc (void);
void dummyfunc (void) {}

int main ()
{
	return 0;
}"
HAVE_VISIBILITY)
if(NOT HAVE_VISIBILITY)
	set(HAVE_VISIBILITY 0)
endif()
