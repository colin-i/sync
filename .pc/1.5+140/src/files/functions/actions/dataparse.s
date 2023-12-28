

#err
Function entryvarsfns(data content,data size)
	Data notype=notype
	Data pointer#1
	SetCall pointer strinvars_ignoreref(content,size,notype)
	Data noerr=noerror
	Data zero=0
	If pointer=zero
		Data fns%%ptr_functions
		SetCall pointer vars_ignoreref(content,size,fns)
		If pointer=zero
			Return noerr
		EndIf
	EndIf

	Char varfndup="Variable/Function name is already defined."
	Str ptrvarfndup^varfndup
	Return ptrvarfndup
EndFunction

#relocated offset or for objects
function get_img_vdata()   #(exandbit & nobits) = .nbsection
	Data value#1
	Data inter#1

	Data ptrimageoff%ptrimagebaseoffset
	Data ptrdataoff%ptrstartofdata

	Set value ptrimageoff#
	Set inter ptrdataoff#
	Add value inter
	return value
endfunction
#same
function get_dataReg()
	vdata ptrdataReg%%ptr_dataReg
	return ptrdataReg#
endfunction
#same
function get_dataSize()
	vdata ptrdataSize%ptrdataSize
	sd reg;set reg ptrdataSize#
	vdata ptr_nobits_virtual%ptr_nobits_virtual
	if ptr_nobits_virtual#=(Yes)
		#this is here because this function is called from fndecargs and from simple declare add reference
		vdata ptr_nobitsDataStart%ptr_nobitsDataStart
		sub reg ptr_nobitsDataStart#
	endif
	return reg
endfunction
#same
function get_img_vdata_dataReg()
	sd reg;setcall reg get_img_vdata()
	addcall reg get_dataReg()
	return reg
endfunction
#same
function get_img_vdata_dataSize()
	sd reg;setcall reg get_img_vdata()
	addcall reg get_dataSize()
	return reg
endfunction

#err
Function addvarreference(sv ptrcontent,sd ptrsize,sd valsize,sd typenumber,sd mask,sd stackoffset,sd is_expand)
	#duplications
	Data content#1
	Set content ptrcontent#
	Data zero=0
	Data constantsnr=constantsnumber
	Data value#1
	Data errnr#1
	Data noerr=noerror
	data false=0

	If typenumber!=constantsnr
		SetCall errnr entryvarsfns(content,valsize)
		If errnr!=noerr
			Return errnr
		EndIf
		data stack#1
		data ptrS^stack
		call stackfilter(typenumber,ptrS)
		if stack=false
			if is_expand=(TRUE)
				setcall value get_img_vdata_dataSize()

				#commented was before expandbit at class scopes
				#sd ptr_nobits_virtual%ptr_nobits_virtual
				#if ptr_nobits_virtual#==(Yes)
				or mask (expandbit)
				#endif
			else
				setcall value get_img_vdata_dataReg()
			endelse
		else
			if stackoffset=zero
				#stack free declared
				setcall value getramp_ebxrel()
				#data ebx_relative=ebxregnumber*tostack_relative
				#or mask ebx_relative
			else
				#stack function argument
				set value stackoffset
				#data ebp_relative=ebpregnumber*tostack_relative
				or mask (stackrelativebit)
			endelse
			or mask (stackbit)
			sd vbool
			if typenumber=(stackvaluenumber);set vbool (TRUE);else;setcall vbool sd_as_sv((sd_as_sv_bool),typenumber);endelse
			if vbool=(TRUE)
				or mask (pointbit)
			endif
		endelse
	Else
		Data structure#1
		SetCall structure getstructcont(constantsnr)
		Data pointer#1
		SetCall pointer vars(content,valsize,structure)
		If pointer!=zero
			Char constdup="Constant name is already defined."
			Str pconstdup^constdup
			Return pconstdup
		EndIf
		#this will be set outside Set value 0
	EndElse

	SetCall errnr addaref(value,ptrcontent,ptrsize,valsize,typenumber,mask)
	Return errnr
EndFunction

#err
function addvarreferenceorunref(sv ptrcontent,sd ptrsize,sd valsize,sd typenumber,sd mask,sd stackoffset,sd is_expand)
	data err#1
	data noerr=noerror

	Data zero=0
	If valsize=zero
		Char _namecverr="Name for variable/constant expected."
		vStr namecverr^_namecverr
		Return namecverr
	EndIf

	data content#1
	set content ptrcontent#
	Char firstchar#1
	Set firstchar content#

	If firstchar!=(unrefsign)
		if firstchar=(throwlesssign)   #throwless if on a throwing area
			If typenumber=(constantsnumber)
				Return "Unexpected throwless sign ('&') at constant declaration."
			EndIf
			dec valsize
			If valsize=zero
				Return "Name for variable expected."
			endif
			or mask (aftercallthrowlessbit)
			call stepcursors(ptrcontent,ptrsize)
		elseIf typenumber!=(constantsnumber)
			sd global_err_pB;setcall global_err_pB global_err_pBool()
			if global_err_pB#=(FALSE)
				or mask (aftercallthrowlessbit)
			endif
		endelseif
		SetCall err addvarreference(ptrcontent,ptrsize,valsize,typenumber,mask,stackoffset,is_expand)
		Return err
	EndIf
	If typenumber=(constantsnumber)
		Char unrefconstant="Unexpected unreference sign ('*') at constant declaration."
		vStr ptrunrefconstant^unrefconstant
		Return ptrunrefconstant
	EndIf
	Call advancecursors(ptrcontent,ptrsize,valsize)
	Return noerr
endfunction

function getsign_size(sd start,sd last,sd mark,sd pdest) #mark is if was ended by a sign or whitespaces
	if start!=mark
		sub mark start
		set pdest# mark
		ret
	endif
	sub last start
	set pdest# last
endfunction
#er
function getsign(ss content,sd size,ss assigntype,sd ptrsz,sd typenumber,sd stack,sd ptrrelocbool,sd ptrdataxrel)
	if size>0
		sd start;set start content
		sd size_mark;set size_mark start
		if content#=(unrefsign)
			call stepcursors(#content,#size)
			add size content
			while content!=size
				if content#!=(assignsign)
					if content#!=(reservesign)
						if content#!=(pointersigndeclare)
							if content#!=(relsign)
								inc content
								continue
							endif
						endif
					endif
				endif
				set size_mark content
				break
			endwhile
		else
			add size content
			while content!=size
				if content#!=(assignsign)
					if content#!=(reservesign)
						if content#!=(pointersigndeclare)
							if content#!=(relsign)
								if content#=(asciispace)
									set size_mark content
									setcall content mem_spaces(content,size)
									break
								elseif content#=(asciitab)
									set size_mark content
									setcall content mem_spaces(content,size)
									break
								endelseif
								inc content
								continue
							endif
						endif
					endif
				endif
				set size_mark content
				break
			endwhile
		endelse
		if content=size
			if stack=(TRUE)
				call getsign_size(start,content,size_mark,ptrsz)
				Set assigntype# (nosign)
				return (noerror)
			endif
		else
			call getsign_size(start,content,size_mark,ptrsz)
			if content#=(assignsign)
				Set assigntype# (assignsign)
				return (noerror)
			elseif content#=(reservesign)
				If typenumber=(constantsnumber)
					Char constreserveerr="Unexpected reserve sign ('#') at constant declaration."
					Str ptrconstreserveerr^constreserveerr
					Return ptrconstreserveerr
				EndIf
				Set assigntype# (reservesign)
				return (noerror)
			elseif content#=(pointersigndeclare)
				If typenumber=(charnumber)
					#grep    stackfilter2 4
					if stack=(FALSE)
						Char ptrchar="Incorrect pointer sign ('^') used at CHAR declaration."
						vStr ptrptrchar^ptrchar
						Return ptrptrchar
					endif
				EndIf
				Set assigntype# (pointersigndeclare)
				If typenumber!=(constantsnumber)
					Set ptrrelocbool# (TRUE)
				EndIf

				return (noerror)
			elseif content#=(relsign)
				Char ptrrelchar="Incorrect relocation sign ('%') used at CHAR/CONST declaration."
				vStr ptrptrrelchar^ptrrelchar
				If typenumber=(charnumber)
					#stackfilter2   grep5
					if stack=(FALSE)
						Return ptrptrrelchar
					endif
				ElseIf typenumber=(constantsnumber)
					Return ptrptrrelchar
				EndElseIf
				Set assigntype# (assignsign)
				Set ptrrelocbool# (TRUE)

				#call advancecursors(#content,#size,valsize)
				#call stepcursors(#content,#size)
				inc content

				if content=size
					return "Size 0 when testing for datax relocation."
				endif
				#this was moved here because of xfile, to know datax relocation
				if content#=(relsign)
					set ptrdataxrel# (TRUE)
				else
					set ptrdataxrel# (FALSE)
				endelse
				return (noerror)
			endelseif
		endelse
	endif
	Char _assignoperatorerr="One from the assign operators expected."
	vStr assignoperatorerr^_assignoperatorerr
	Return assignoperatorerr
endfunction
