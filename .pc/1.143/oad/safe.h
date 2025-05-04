
//typedef long long long;//on windows but later

//only to not truncate void* return to int, args are not truncated at default, if they are then must long them at default

//gcc/clang with __has_builtin
//not the same as #ifndef __builtin_malloc
//old gcc cannot do in one line if __has_builtin is not: #if (! defined(__has_builtin)) || (! __has_builtin(__builtin_malloc))
#undef ok_lets_define_the_function

#if defined(__has_builtin)
#	if ! __has_builtin(__builtin_malloc)
#		define ok_lets_define_the_function
#	endif
#endif
#ifdef ok_lets_define_the_function
#	undef ok_lets_define_the_function
	void*malloc(long unsigned int); //builtin will warn, for example, if arg is char*
#endif

#if defined(__has_builtin)
#	if ! __has_builtin(__builtin_realloc))
#		define ok_lets_define_the_function
#	endif
#endif
#ifdef ok_lets_define_the_function
#	undef ok_lets_define_the_function
void*realloc(void*,long unsigned int);
#endif

#if defined(__has_builtin)
#	if ! __has_builtin(__builtin_strlen))
#		define ok_lets_define_the_function
#	endif
#endif
#ifdef ok_lets_define_the_function
#	undef ok_lets_define_the_function
long unsigned int strlen(const char*);
#endif
