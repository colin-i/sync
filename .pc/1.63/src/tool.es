Format ElfObj64

import "erbool" erbool
functionx erbool_get()
    ss p;setcall p erbool()
    return p#
endfunction

functionx erbool_reset()
    ss p;setcall p erbool()
    set p# 0
endfunction

include "../include/prog.h"

functionx freereset()
#this is called by user only if want to abort after some calls
#               and at some frees
	import "debug_free" debug_free
	call debug_free()
	#free and set initial null/-1.....
	import "swf_mem" swf_mem
	call swf_mem((mem_exp_free))
endfunction
