#include <stdio.h>

#define myprintf(format,...) printf(format,__VA_ARGS__)

void ifdef_inside_variadic_macro()
{
	myprintf("%s\n",
	#ifdef SOMETHING
	"hello"
	#else
	"bye"
	#endif
	);
}

void elvis_operator()
{
	int a = 5 ?: 10; // if '5' is true then 5 else 10
}

void const_size_array()
{
	const int a = 5;
	int b[a];
}
