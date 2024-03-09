Format ElfObj64

include "../include/prog.h"

import "action_debug" action_debug
import "brace_blocks_counter_init" brace_blocks_counter_init
import "action_code_values" action_code_values
import "action_code_values_index" action_code_values_index
import "escape_action" escape_action
import "action_debug_free" action_debug_free



aftercallimport ebool

#this/an action

import "action__code_row" action__code_row
import "action_code_set" action_code_set
import "action_code_row" action_code_row
import "dupreserve_string" dupreserve_string
import "brace_blocks_end" brace_blocks_end
function action_base(ss ac)
#ss ac       actionscript string to be parsed
    sd p_values
    setcall p_values action_code_values()
    import "error" error
    if p_values=(NULL);call error("Don't call the action now.");endif
    #
    sd nr
    setcall nr action_code_values_index()
    set nr# 0
    call brace_blocks_counter_init()
    #
    ss mem
    setcall mem dupreserve_string(ac)
    sd p_action_errors
    setcall p_action_errors action_debug((TRUE))
    set p_action_errors# (TRUE)
	sv cursor;set cursor p_action_errors;add cursor (DWORD);set cursor# ac;add cursor :;set cursor# mem

	import "debug_action_init" debug_action_init
	call debug_action_init(ac)

    call escape_action(ac,mem,0)

	import "debug_action_phase" debug_action_phase
	call debug_action_phase()

    while mem#!=0
        setcall mem action_code_row(mem,(FALSE))
    endwhile
    call action_code_set((math_end))

    #set false to stop adding row nr at errors
    set p_action_errors# (FALSE)

    call brace_blocks_end()

	call debug_action_phase()

	#                 code_values are not reallocated
	while p_values#!=(math_end)
		setcall p_values action__code_row(p_values)
	endwhile

    #free mem ok,another free can be at errors
    call action_debug_free()
endfunction
