
const Xfile_sz_char=bsz
const Xfile_sz_int=dwsz
const Xfile_function_not_x=Xfile_function_traw
const Xfile_decltype_const=Xfile_decltype_longByte+1

#err
function xfile_add_int(sd int)
	sd err;setcall err writefile_errversion(main.xfile,#int,(Xfile_sz_int))
	return err
endfunction
#err
function xfile_add_int_if(sd int)
	if main.xfile!=(openno)
		sd err;setcall err xfile_add_int(int)
		return err
	endif
	return (noerror)
endfunction
function xfile_add_char(sd type)
	sd err;setcall err writefile_errversion(main.xfile,#type,(Xfile_sz_char))
	return err
endfunction
function xfile_add_char_if(sd type)
	if main.xfile!=(openno)
		sd err;setcall err writefile_errversion(main.xfile,#type,(Xfile_sz_char))
		return err
	endif
	return (noerror)
endfunction
function xfile_add_char_ifif(sd type)
	if main.parses=(pass_write)
		sd err;setcall err xfile_add_char_if(type)
		return err
	endif
	return (noerror)
endfunction
function xfile_add_string(sd text,sd size)
	sd err;setcall err writefile_errversion(main.xfile,#size,(Xfile_sz_int))
	if err=(noerror)
		setcall err writefile_errversion(main.xfile,text,size)
	endif
	return err
endfunction
function xfile_add_string_if(sd text,sd size)
	if main.xfile!=(openno)
		sd err
		setcall err xfile_add_string(text,size)
		return err
	endif
	return (noerror)
endfunction
function xfile_add_base(sd type,sd text,sd size)
	sd err;setcall err writefile_errversion(main.xfile,#type,(Xfile_sz_char))
	if err=(noerror)
		setcall err xfile_add_string(text,size)
	endif
	return err
endfunction
function xfile_add_base_if(sd type,sd text,sd size)
	if main.xfile!=(openno)
		sd err;setcall err xfile_add_base(type,text,size)
		return err
	endif
	return (noerror)
endfunction
function xfile_add_base_ifif(sd type,sd text,sd size)
	if main.parses=(pass_write)
		sd err;setcall err xfile_add_base_if(type,text,size)
		return err
	endif
	return (noerror)
endfunction
function xfile_add_base_area_if(sd type,sd start,sd end)
	sub end start
	sd e;setcall e xfile_add_base_if(type,start,end)
	return e
endfunction
function xfile_add_comment_ifif(sd start,sd end)
	if main.parses=(pass_write)
		inc start ##one for commentascii
		sd e;setcall e xfile_add_base_area_if((Xfile_comment),start,end)
		return e
	endif
	return (noerror)
endfunction
function xfile_add_comment_multi_ifif(sd start,sd end)
	if main.parses=(pass_write)
		add start 2 #one for commentascii and one for asciiexclamationmark
		sd e;setcall e xfile_add_base_area_if((Xfile_multicomment),start,end)
		return e
	endif
	return (noerror)
endfunction
