Format ElfObj64

include "../include/prog.h"

#this has throws but for mem_exp_change and back are not required
import "swf_actionblock" swf_actionblock


aftercallimport ebool

#this/an action

import "action_base" action_base
import "action_format" action_format
import "debug_base" debug_base

functionX action(ss ac)
#ss ac       actionscript string to be parsed
	call debug_base(0)
	call action_base(ac)
endfunction
functionXx actionf(ss buffer,ss *format)
#ss buffer   the buffer where to sprintf the format and the arguments
#ss format   the format
#...         % arguments here
	call debug_base(0)
	call action_format(#buffer)
endfunction

#sprite

functionX action_sprite(sd sprite,ss actions)
#sd sprite    sprite id
#ss actions   same as action
	call debug_base(sprite)
    call swf_actionblock((mem_exp_change),sprite)
    call action_base(actions)
    call swf_actionblock((mem_exp_change_back))
endfunction
functionXx actionf_sprite(sd sprite,ss buffer,ss *format)
#sd sprite    sprite id
#ss buffer    same as actionf
#ss format    same as actionf
	call debug_base(sprite)
    call swf_actionblock((mem_exp_change),sprite)
    call action_format(#buffer)
    call swf_actionblock((mem_exp_change_back))
endfunction
