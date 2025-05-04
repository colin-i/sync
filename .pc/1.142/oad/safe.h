
//typedef long long long;//on windows but later

//only to not truncate void* return to int, args are not truncated at default, if they are then must long them at default

//gcc/clang with __has_builtin    //not the same as #ifndef __builtin_malloc
#if (! defined(__has_builtin)) || (! __has_builtin (__builtin_malloc))
void*malloc(long unsigned int); //builtin will warn, for example, if arg is char*
#endif
#if (! defined(__has_builtin)) || (! __has_builtin (__builtin_realloc))
void*realloc(void*,long unsigned int);
#endif
#if (! defined(__has_builtin)) || (! __has_builtin (__builtin_strlen))
long unsigned int strlen(const char*);
#endif
