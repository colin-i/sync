
#err
Function unresolvedcallsfn(data struct,data inneroffset,data atend,data valuedata)
	data structure#1
	Data offset#1
	data addatend#1

	Data poff^offset
	Call getcontReg(struct,poff)
	add offset inneroffset

	Data err#1
	Data true=TRUE
	Data ptrobject%ptrobject

	If ptrobject#=true
		Data ptrextra%%ptr_extra
		SetCall err addrel_base(offset,valuedata,atend,ptrextra)
	Else
		#add to resolve at end
		Data unressz=3*dwsz
		Data uncall%%ptr_unresolvedcalls
		data ptrstruct^structure

		set structure struct
		set addatend atend

		SetCall err addtosec(ptrstruct,unressz,uncall)
	EndElse
	Return err
EndFunction

#err
function fnimp_exists(sd content,sd size)
	sd fns%%ptr_functions
	sd d;setcall d vars_ignoreref(content,size,fns)
	if d=0
		return (noerror)
	endif
	return "Function/Import name is already defined."
endfunction
#xf
function func_xfile(sd subtype)
	if subtype=(cFUNCTION) #Xfile_function_tintern
		return (Xfile_function_not_x)
	endif
	return subtype ##Xfile_function_traw Xfile_function_extern Xfile_function_entry
endfunction
#err
Function parsefunction(data ptrcontent,data ptrsize,data is_declare,sd subtype,sd el_or_e,sd varargs)
	Data true=TRUE
	#Data false=FALSE

	Data zero=0
	Data fns%%ptr_functions
	Data code%%ptr_codesec

	Data err#1
	Data noerr=noerror

	Str content#1
	Data size#1
	Data sz#1

	Set content ptrcontent#
	Set size ptrsize#

	SetCall sz valinmem(content,size,(asciiparenthesisstart))
	If sz=zero
		Char funnameexp="Function name expected."
		Str fnerr^funnameexp
		Return fnerr
	EndIf
	If sz=size
		Char startfnexp="Open parenthesis sign ('(') expected."
		Str starterr^startfnexp
		Return starterr
	EndIf

	vdata p_parses%ptr_parses
	sd parses;set parses p_parses#

	If is_declare=true
		Data fnnr=functionsnumber
		Data value#1
		Data ptrvalue^value
		if parses=(pass_init)
			setcall err fnimp_exists(content,sz) #it is at first pass when only fns and imports are
			if err!=(noerror)
				return err
			endif

			Data mask#1
			#Data ptrobjfnmask%ptrobjfnmask
			if el_or_e=(TRUE)
				Set mask (referencebit)
			else
				call vars_log_set(content,sz) #more at the function
				set mask 0
			endelse
			sd can_scope64
			setcall can_scope64 func_xfile(subtype)
			if can_scope64!=(Xfile_function_not_x)
				or mask (x86_64bit)
			endif
			sd err_pb;setcall err_pb global_err_pBool()
			if err_pb#=(FALSE)
				or mask (aftercallthrowlessbit)
			endif

			SetCall err addaref(value,ptrcontent,ptrsize,sz,fnnr,mask)
			If err!=noerr
				Return err
			EndIf

			#before virtuals
			#skip the rest of the command at recon
			#Call advancecursors(ptrcontent,ptrsize,ptrsize#)
			#
			#return noerr
		else
			if el_or_e=(FALSE)
				call scopes_store_class()
			endif

			#pass_write
			sd pointer
			setcall pointer vars_ignoreref(content,sz,fns)
			Call advancecursors(ptrcontent,ptrsize,sz)

			#add the function name to the code section if the option is set
			sd fn_text
			setcall fn_text fn_text_info()
			if fn_text#=1
				sd fn_name
				set fn_name pointer
				add fn_name (nameoffset)
				sd len
				setcall len strlen(fn_name)
				inc len
				SetCall err addtoCode_set_programentrypoint(fn_name,len)
				If err!=(noerror)
					Return err
				EndIf
			endif

			Call getcontReg(code,ptrvalue)
			set pointer# value

			#resolve the previous calls at this value
			Data ptrobject%ptrobject
			If ptrobject#=true
				Data STT_FUNC=STT_FUNC
				Data codeind=codeind
				Data ptrtable%%ptr_table
				if subtype!=(cFUNCTION)
				#entries are also not local
					SetCall err elfaddstrszsym(content,sz,value,zero,STT_FUNC,(STB_GLOBAL),codeind,ptrtable)
				else
					SetCall err elfaddstrszsym(content,sz,value,zero,STT_FUNC,(STB_WEAK),codeind,ptrtable)
				endelse
				If err!=noerr
					Return err
				EndIf
			EndIf

			if subtype=(cFUNCTION)
				call scope64_set((FALSE))
				setcall err xfile_add_fndef_if(content,sz,(Xfile_function_tintern),(Xfile_function_not_x)) #,arg
			else
				#functionx,entry in 64 conventions
				if subtype!=(Xfile_function_traw)
					sd scope64
					setcall scope64 is_for_64()
					call scope64_set(scope64)
				else
				#if subtype==(cENTRYRAW)
				#entryraw has no return but has argc,aexec,a1...an
					setcall err entryraw_top();if err!=noerr;Return err;EndIf

					#set only to avoid at start args, else, not using, never get into getreturn here
					call scope64_set((FALSE))
				endelse
				setcall err xfile_add_fndef_if(content,sz,subtype,subtype,varargs)
			endelse
			If err!=noerr
				Return err
			EndIf
		endelse
	Else
		Data ptrdata#1
		if parses=(pass_init)
			call advancecursors(ptrcontent,ptrsize,sz)
		elseif parses=(pass_calls)
			SetCall ptrdata vars_ignoreref(content,sz,fns)
			if ptrdata!=0
				call is_for_64_is_impX_or_fnX_set(ptrdata,subtype)
			else
				call is_for_64_is_impX_or_fnX_set_force(subtype)
			endelse
			call advancecursors(ptrcontent,ptrsize,sz)
		else
			#pass_write
			data boolindirect#1
			setcall err prepare_function_call(ptrcontent,ptrsize,sz,#ptrdata,#boolindirect,subtype)
			if err!=(noerror)
				return err
			endif
		endelse
	EndElse

	Call stepcursors(ptrcontent,ptrsize)
	data ptr_sz^sz
	setcall err parenthesis_size(ptrcontent#,ptrsize#,ptr_sz)
	if err!=noerr
		return err
	endif

	If is_declare=true
		if parses=(pass_write)
			sd nr_of_args_tested=0
			if sz!=zero
				sv c;sd s;set c ptrcontent#;set s ptrsize#
				Call enumcommas(#c,#s,sz,is_declare,fnnr,(pass_write0),#nr_of_args_tested) #there are 4 more arguments but are not used
			endif
			setcall err xfile_add_int_if(nr_of_args_tested)
			If err!=noerr
				Return err
			EndIf

			sd b;setcall b scope64_get()
			if b=(TRUE)
				if varargs!=0
					sd nr_of_args
					setcall nr_of_args convdata((convdata_total))
					setcall err function_start_64(nr_of_args)
				else
					setcall err function_start_64(nr_of_args_tested)
				endelse
				If err!=noerr
					Return err
				EndIf
			endif
		endif
		If sz!=zero
			SetCall err enumcommas(ptrcontent,ptrsize,sz,is_declare,fnnr,parses) #there are 5 more arguments but are not used
			if err!=noerr
				return err
			endif
		EndIf
		if parses=(pass_write)
			call entryscope()
		endif
	Else
		if parses=(pass_init)
			if sz!=zero
				SetCall err enumcommas(ptrcontent,ptrsize,sz,is_declare,parses) #there are 6 more arguments but are not used
				if err!=noerr
					return err
				endif
			endif
		else
			sd p
			sd pbool;setcall pbool is_for_64_is_impX_or_fnX_p_get()
			if parses=(pass_calls)
				if pbool#=(FALSE)
					call advancecursors(ptrcontent,ptrsize,sz)
				else
					if sz!=zero
						setcall p nr_of_args_64need_p_get();set p# 0
						SetCall err enumcommas(ptrcontent,ptrsize,sz,is_declare,parses) #there are 6 more arguments but are not used
						if err=noerr
							setcall err align_ante(p#)
						endif
					else
						setcall err align_ante(0)
					endelse
					if err!=noerr
						return err
					endif
					set pbool# (FALSE)
				endelse
			else
				#pass_write

				if pbool#=(FALSE)
					if sz!=zero
						setcall err xfile_add_commas_interncall_if(ptrcontent#,ptrsize#,sz)
						if err=(noerror)
							SetCall err enumcommas(ptrcontent,ptrsize,sz,is_declare,parses) #there are 6 more arguments but are not used
							if err!=noerr;return err;endif
						else
							return err
						endelse
					endif
				else
					setcall p nr_of_args_64need_p_get();set p# 0 #also at 0 at win will be sub all shadow space
					if sz!=zero
						set content ptrcontent#
						set size ptrsize#
						SetCall err enumcommas(#content,#size,sz,is_declare,(pass_calls)) #there are 6 more arguments but are not used
						if err=noerr
							setcall err stack_align(p#)
							if err=noerr
								setcall err xfile_add_int_if(p#)
								if err=noerr
									SetCall err enumcommas(ptrcontent,ptrsize,sz,is_declare,parses) #there are 6 more arguments but are not used
								else
									return err
								endelse
							else
								return err
							endelse
						else
							return err
						endelse
					else
						setcall err stack_align(0)
					endelse
					if err!=noerr;return err;endif
				endelse

				setcall err write_function_call(ptrdata,boolindirect,(FALSE))
				if err!=noerr;return err;endif
			endelse
		endelse
	EndElse
	Call stepcursors(ptrcontent,ptrsize)
	Return noerr
EndFunction
#p
function fn_text_info()
	data text_info#1
	return #text_info
endfunction

#err
function prepare_function_call(sd pcontent,sd psize,sd sz,sd p_data,sd p_bool_indirect,sd subtype)
	Data fns%%ptr_functions

	SetCall p_data# vars(pcontent#,sz,fns)
	If p_data#=0
		setcall p_data# vars_number(pcontent#,sz,(integersnumber))
		If p_data#=0
			setcall p_data# vars_number(pcontent#,sz,(stackdatanumber))
			If p_data#=0
				setcall p_data# vars_number(pcontent#,sz,(stackvaluenumber))
				If p_data#=0
					Char unfndeferr="Undefined function/data call."
					Str ptrunfndef^unfndeferr
					Return ptrunfndef
				EndIf
			EndIf
		EndIf
		set p_bool_indirect# (TRUE)
		call is_for_64_is_impX_or_fnX_set_force(subtype)
	Else
		#at functions
		set p_bool_indirect# (FALSE)
		call is_for_64_is_impX_or_fnX_set(p_data#,subtype)
	EndElse

	sd err
	setcall err xfile_add_call_if(pcontent#,sz,subtype)
	if err=(noerror)   #here is coming from calls and callex
		Call advancecursors(pcontent,psize,sz)

		#move over the stack arguments, ebx is also shorting the first stack variable (mov rbx,rdx)
		#mov esp,ebx
		Data code%%ptr_codesec
		#
		setcall err rex_w_if64();if err!=(noerror);return err;endif
		#
		char espebx={moveatregthemodrm,0xe3}
		Str ptrespebx^espebx
		Data sizeespebx=2
		SetCall err addtosec(ptrespebx,sizeespebx,code)
	endif
	Return err
endfunction

#err
function write_function_call(sd ptrdata,sd boolindirect,sd is_callex)
	sd err
	Data code%%ptr_codesec

	sd pb;setcall pb is_for_64_is_impX_or_fnX_p_get()
	if pb#=(TRUE)
		setcall err function_call_64(is_callex)
		If err!=(noerror);Return err;EndIf
		set pb# (FALSE) #reset the flag
	endif

	Data ptrfnmask#1
	Set ptrfnmask ptrdata
	Add ptrfnmask (maskoffset)

	data mask#1
	Data idatamask#1
	Data idatafn=idatabitfunction
	Data ptrobject%ptrobject
	Set mask ptrfnmask#
	set idatamask mask
	And idatamask idatafn

	sd is_valuedata_call;set is_valuedata_call boolindirect
	If ptrobject#=(FALSE)
		If idatamask=idatafn
			Set boolindirect (TRUE)
		EndIf
	EndIf

	If boolindirect=(FALSE)
		Char directcall#1
		Data directcalloff#1

		Data ptrdirectcall^directcall
		const directcallsize=1+dwsz
		data ptrdirectcalloff^directcalloff

		If idatamask!=idatafn
			set directcall 0xe8
			setcall err unresolvedLocal(1,code,ptrdata,ptrdirectcalloff)
			If err!=(noerror);Return err;EndIf
			SetCall err addtosec(ptrdirectcall,(directcallsize),code)
		Else
			#was: reloc when linking;0-dwsz(appears to be dwsz from Data directcallsize=1+dwsz), no truncation, so direct better
			set directcall 0xb8
			Set directcalloff 0
			sd relocoff
			setcall relocoff reloc64_offset(1)
			SetCall err unresolvedcallsfn(code,relocoff,directcalloff,ptrdata#);If err!=(noerror);Return err;EndIf
			setcall err reloc64_ante();If err!=(noerror);Return err;EndIf
			SetCall err addtosec(ptrdirectcall,(directcallsize),code);If err!=(noerror);Return err;EndIf
			setcall err reloc64_post();If err!=(noerror);Return err;EndIf
			char callcode={0xff,0xd0}
			setcall err addtosec(#callcode,2,code)
		EndElse
	Else
		#this at object is call data() but the reloc is outside of this function
		if idatamask=idatafn
			data ptrvirtualimportsoffset%ptrvirtualimportsoffset
			SetCall err unresolvedcallsfn(code,1,ptrvirtualimportsoffset) #,ptrdata#
			If err!=(noerror);Return err;EndIf
		endif
		Char callaction={0xff}
		#Data noreg=noregnumber
		Char callactionopcode={2}
		Data eaxregnumber=eaxregnumber
		#call stack64_op_set()
		SetCall err writeopera(ptrdata,callaction,callactionopcode,eaxregnumber) #no sufix was
	EndElse
	If err!=(noerror)
		Return err
	EndIf

	#afterbit throwless is at fns imps if before aftercall; at values is throwless after aftercall if sign set
	sd tless=aftercallthrowlessbit
	and tless mask
	if tless=0
		if is_valuedata_call=(FALSE)
			sd global_err_pB;setcall global_err_pB global_err_pBool()
			if global_err_pB#=(FALSE)
				set tless -1    #don't want to throw before aftercall
			endif
		endif
	endif
	if tless=0
		sd global_err_ptr;setcall global_err_ptr global_err_p()
		Data ptrextra%%ptr_extra
		If ptrobject#=(FALSE)
		#absolute
			const global_err_ex_start=\
			#mov ecx,imm32
			char g_err_mov=0xb8+ecxregnumber;data g_err_mov_disp32#1
			#cmp byte[ecx],0
			char *={0x80,7*toregopcode|ecxregnumber};char *=aftercall_disable
			const global_err_ex_sz=\-global_err_ex_start
			#add rel,1 is (b8+ecx), one byte
			set g_err_mov_disp32 global_err_ptr#
			#
			SetCall err addtosec(#g_err_mov,(global_err_ex_sz),code)
		Else
			#mov to ecx is reseting the high part of the rcx
			char g_err=0xb9
			data *rel=0
			#
			sd af_relof
			setcall af_relof reloc64_offset((bsz))
			setcall err adddirectrel_base(ptrextra,af_relof,global_err_ptr#,0);If err!=(noerror);Return err;EndIf
			setcall err reloc64_ante();If err!=(noerror);Return err;EndIf
			SetCall err addtosec(#g_err,5,code);If err!=(noerror);Return err;EndIf
			setcall err reloc64_post();If err!=(noerror);Return err;EndIf
			char g_cmp={0x80,7*toregopcode|ecxregnumber,0}
			SetCall err addtosec(#g_cmp,3,code)
		EndElse
		If err!=(noerror);Return err;EndIf
		#jz
		char g_err_jz=0x74;char ret_end_sz#1
		#
		ss ret_end_p
		sd is_linux_term;setcall is_linux_term is_linux_end()
		if is_linux_term=(TRUE)
			#int 0x80, sys_exit, eax 1,ebx the return number
			const g_err_sys_start=\
			char g_err_sys={0x8b,ebxregnumber*toregopcode|0xc0|eaxregnumber}
			char *={0xb8,1,0,0,0}
			Char *={intimm8,0x80}
			const g_err_sys_size=\-g_err_sys_start
			set ret_end_sz (g_err_sys_size)
			set ret_end_p #g_err_sys
		else
			setcall ret_end_sz getreturn(#ret_end_p)
		endelse
		SetCall err addtosec(#g_err_jz,(bsz+bsz),code);If err!=(noerror);Return err;EndIf
		#return
		SetCall err addtosec(ret_end_p,ret_end_sz,code)
		#;If err!=(noerror);Return err;EndIf
	endif

	return err
endfunction

#p
function global_err_p()
	data e#1
	return #e
endfunction
#p
function global_err_pBool()
	data bool#1
	return #bool
endfunction

#bool
function is_linux_end()
	sd ptrfnavailable%ptrfnavailable
	if ptrfnavailable#=0  #one is default, two from multiple entry start detectors and from entry tags
	#here innerfunction is also practical, but that is more for data offsets
		sd p_exit_end%p_exit_end
		return p_exit_end#
	endif
	return (FALSE) #not at inner functions
endfunction
#er
function entryraw_top()
	char s={0x6a,0}
	data code%%ptr_codesec
	sd err
	setcall err addtosec(#s,2,code)
	return err
endfunction

#err
function aftercall_manipulate(sd acall_val)
	sd err
	vData ptrobject%ptrobject
	vData ptrextra%%ptr_extra
	vData code%%ptr_codesec
	sd global_err_ptr;setcall global_err_ptr global_err_p()

	If ptrobject#=(FALSE)
	#absolute
		#mov [disp32],imm8 /0
		char a=0xc6;char *=disp32regnumber;data b#1;char c#1
		set b global_err_ptr#
		set c acall_val
		SetCall err addtosec(#a,7,code)
	Else
		#for a 64 rel: 0xc6/0xc7 is still disp32; and rex is nothing at 0xc6
		sd normal_offset=bsz
		sd af_relof
		setcall af_relof reloc64_offset(normal_offset)

		if af_relof!=normal_offset
			char a64={REX_Operand_64,ateaximm+ecxregnumber};data *=reloc64_main;data *=reloc64_main
			char *=0xc6;char *=ecxregnumber;char val#1

			setcall err adddirectrel_base(ptrextra,af_relof,global_err_ptr#,0);If err!=(noerror);Return err;EndIf

			set val acall_val
			SetCall err addtosec(#a64,(10+3),code)
		else
			char g_err=0xc6;char *=disp32regnumber;data *rel=0;char val32#1

			setcall err adddirectrel_base(ptrextra,(bsz+bsz),global_err_ptr#,0);If err!=(noerror);Return err;EndIf

			set val32 acall_val
			SetCall err addtosec(#g_err,7,code)
		endelse
	EndElse
	return err
endfunction
