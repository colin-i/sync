
if g_e_b_p#=(FALSE)
	set errormsg "AfterCall is not defined."
else
	setcall errormsg xfile_add_char_if((Xfile_aftercall))
	if errormsg=(noerror)
		sd acall_val
		if subtype=(cAFTERCALLENABLE)
			set acall_val (~aftercall_disable)
			setcall errormsg xfile_add_char_if((Xfile_aftercall_enable))
		else
		#cAFTERCALLDISABLE
			set acall_val (aftercall_disable)
			setcall errormsg xfile_add_char_if((Xfile_aftercall_disable))
		endelse
		if errormsg=(noerror)
			setcall errormsg aftercall_manipulate(acall_val)
		endif
	endif
endelse
