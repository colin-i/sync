
#err
function writeret()
	sd err
	sd termswitch
	sd continuation
	sd continuationsize
	setcall termswitch is_linux_end()
	if termswitch==(TRUE)
		setcall err getexit(#continuation,#continuationsize)
		if err==(noerror)
			Data ptrcodesec%%ptr_codesec
			setcall err addtosec(continuation,continuationsize,ptrcodesec)
		endif
	else
		setcall continuationsize getreturn(#continuation)
		setcall err addtosec(continuation,continuationsize,ptrcodesec)
	endelse
	return err
endfunction

#err
function after_after_call(sd subtype)
	and subtype (call_ret_flag)
	if subtype!=0
		sd err
		setcall err writeret()
		return err
	endif
	return (noerror)
endfunction