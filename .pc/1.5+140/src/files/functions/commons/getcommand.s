

Const spacereq=1
Const spacenotreq=0

#with caution like elseif before else for getcommand comparations, only at space not required (elseif/else, endelseif/endelse, end../end, return/ret)
#and shl1,i3,... are ok, only AZ are going to az

Char cCOMMENT_c={commentascii,0}
Char cDATA_c="DATA";Char cSTR_c="STR";Char cCHAR_c="CHAR";Char cWORD_c="WORD";Char cSD_c="SD";Char cSS_c="SS";Char cSV_c="SV";Char cSW_c="SW"
	Char cVDATA_c="VDATA";Char cVSTR_c="VSTR";Char cVALUE_c="VALUE";Char cVWORD_c="VWORD"
	Char cDATAX_c="DATAX";Char cSTRX_c="STRX";Char cCHARX_c="CHARX";Char cWORDX_c="WORDX"
	Char cVDATAX_c="VDATAX";Char cVSTRX_c="VSTRX";Char cVALUEX_c="VALUEX";Char cVWORDX_c="VWORDX"
	Char cCONST_c="CONST"
Char cSET_c="SET";Char cADD_c="ADD";Char cSUB_c="SUB";Char cMULT_c="MULT";Char cDIV_c="DIV";Char cDIVU_c="DIVU";Char cREM_c="REM";Char cREMU_c="REMU";Char cAND_c="AND";Char cOR_c="OR";Char cXOR_c="XOR"
Char cRETURN_c="RETURN";Char cINC_c="INC";Char cDEC_c="DEC";Char cINCST_c="INCST";Char cDECST_c="DECST";Char cNEG_c="NEG";Char cNOT_c="NOT";Char cSHL1_c="SHL1";Char cSHR1_c="SHR1";Char cSAR1_c="SAR1";Char cEXIT_c="EXIT"
Char cCALL_c="CALL";Char cCALLX_c="CALLX"
Char cIF_c="IF";Char cELSEIF_c="ELSEIF";Char cELSE_c="ELSE";Char cENDIF_c="ENDIF";Char cENDELSEIF_c="ENDELSEIF";Char cENDELSE_c="ENDELSE";Char cWHILE_c="WHILE";Char cENDWHILE_c="ENDWHILE";Char cBREAK_c="BREAK";Char cCONTINUE_c="CONTINUE"
Char cIMPORT_c="IMPORT";Char cIMPORTX_c="IMPORTX"
Char cFUNCTION_c="FUNCTION";Char cFUNCTIONX_c="FUNCTIONX";Char cENTRY_c="ENTRY";Char cENTRYRAW_c="ENTRYRAW"
Char cENDFUNCTION_c="ENDFUNCTION"
Char cEND_c="END"
Char cRET_c="RET"
Char cINCLUDE_c="INCLUDE";Char cEINCLUDE_c="EINCLUDE"
Char cFORMAT_c="FORMAT"
Char cAFTERCALLIMPORT_c="AFTERCALLIMPORT";Char cAFTERCALL_c="AFTERCALL"
Char cAFTERCALLENABLE_c="AFTERCALLENABLE";Char cAFTERCALLDISABLE_c="AFTERCALLDISABLE"
Char cCALLEX_c="CALLEX";Char cCALLEXX_c="CALLEXX"
Char cLIBRARY_c="LIBRARY"
Char cHEX_c="HEX"
Char cOVERRIDE_c="OVERRIDE"
Char cORPHAN_c="ORPHAN"
Char cI3_c="I3"

const not_a_subtype=-1

const coms_start=\
	Const cCOMMENT=\-coms_start
		data cCOMMENT_s^cCOMMENT_c
Const comsloc^cCOMMENT_s
		Data *=cCOMMENT
		Data *#1
		Data *=spacenotreq
const commandsvars_start=\
	Const cDECLARE=\-coms_start
	Const cDECLARE_top=\
		Const cDATA=\-cDECLARE_top
			data cDATA_s^cDATA_c
Const cdataloc^cDATA_s
			Data *=cDECLARE
			Data *=cDATA
			Data *=spacereq
		Const cSTR=\-cDECLARE_top
Const com_size=cSTR-cDATA
			data *^cSTR_c
			Data *=cDECLARE
			Data *=cSTR
			Data *=spacereq
		Const cCHAR=\-cDECLARE_top
			data *^cCHAR_c
			Data *=cDECLARE
			Data *=cCHAR
			Data *=spacereq
		Const cWORD=\-cDECLARE_top
			data *^cWORD_c
			Data *=cDECLARE
			Data *=cWORD
			Data *=spacereq
		Const cSD=\-cDECLARE_top
			data *^cSD_c
			Data *=cDECLARE
			Data *=cSD
			Data *=spacereq
		Const cSS=\-cDECLARE_top
			data *^cSS_c
			Data *=cDECLARE
			Data *=cSS
			Data *=spacereq
		Const cSV=\-cDECLARE_top
			data *^cSV_c
			Data *=cDECLARE
			Data *=cSV
			Data *=spacereq
		Const cSW=\-cDECLARE_top
			data *^cSW_c
			Data *=cDECLARE
			Data *=cSW
			Data *=spacereq
		Const cVDATA=\-cDECLARE_top
			data *^cVDATA_c
			Data *=cDECLARE
			Data *=cVDATA
			Data *=spacereq
		Const cVSTR=\-cDECLARE_top
			data *^cVSTR_c
			Data *=cDECLARE
			Data *=cVSTR
			Data *=spacereq
		Const cVALUE=\-cDECLARE_top
			data *^cVALUE_c
			Data *=cDECLARE
			Data *=cVALUE
			Data *=spacereq
		Const cVWORD=\-cDECLARE_top
			data *^cVWORD_c
			Data *=cDECLARE
			Data *=cVWORD
			Data *=spacereq
		Const cDATAX=\-cDECLARE_top
			data *^cDATAX_c
			Data *=cDECLARE
			Data *=cDATAX
			Data *=spacereq
		Const cSTRX=\-cDECLARE_top
			data *^cSTRX_c
			Data *=cDECLARE
			Data *=cSTRX
			Data *=spacereq
		Const cCHARX=\-cDECLARE_top
			data *^cCHARX_c
			Data *=cDECLARE
			Data *=cCHARX
			Data *=spacereq
		Const cWORDX=\-cDECLARE_top
			data *^cWORDX_c
			Data *=cDECLARE
			Data *=cWORDX
			Data *=spacereq
		Const cVDATAX=\-cDECLARE_top
			data *^cVDATAX_c
			Data *=cDECLARE
			Data *=cVDATAX
			Data *=spacereq
		Const cVSTRX=\-cDECLARE_top
			data *^cVSTRX_c
			Data *=cDECLARE
			Data *=cVSTRX
			Data *=spacereq
		Const cVALUEX=\-cDECLARE_top
			data *^cVALUEX_c
			Data *=cDECLARE
			Data *=cVALUEX
			Data *=spacereq
		Const cVWORDX=\-cDECLARE_top
			data *^cVWORDX_c
			Data *=cDECLARE
			Data *=cVWORDX
			Data *=spacereq
#numberofcommandsvars to set these commands to search for them at function parameter declare
Const numberofcommandsvars=(\-commandsvars_start)/com_size
		Const cCONST=\-cDECLARE_top
			data *^cCONST_c
			Data *=cDECLARE
			Data *=cCONST
			Data *=spacereq
	Const cPRIMSEC=\-coms_start
	Const cPRIMSEC_top=\
		Const cSET=\-cPRIMSEC_top
			data *^cSET_c
			Data *=cPRIMSEC
			Data *=cSET
			Data *=spacereq
		Const cADD=\-cPRIMSEC_top
			data *^cADD_c
			Data *=cPRIMSEC
			Data *=cADD
			Data *=spacereq
		Const cSUB=\-cPRIMSEC_top
			data *^cSUB_c
			Data *=cPRIMSEC
			Data *=cSUB
			Data *=spacereq
		Const cMULT=\-cPRIMSEC_top
			data *^cMULT_c
			Data *=cPRIMSEC
			Data *=cMULT
			Data *=spacereq
		Const cDIV=\-cPRIMSEC_top
			data *^cDIV_c
			Data *=cPRIMSEC
			Data *=cDIV
			Data *=spacereq
		Const cDIVU=\-cPRIMSEC_top
			data *^cDIVU_c
			Data *=cPRIMSEC
			Data *=cDIVU
			Data *=spacereq
		Const cREM=\-cPRIMSEC_top
			data *^cREM_c
			Data *=cPRIMSEC
			Data *=cREM
			Data *=spacereq
		Const cREMU=\-cPRIMSEC_top
			data *^cREMU_c
			Data *=cPRIMSEC
			Data *=cREMU
			Data *=spacereq
		Const cAND=\-cPRIMSEC_top
			data *^cAND_c
			Data *=cPRIMSEC
			Data *=cAND
			Data *=spacereq
		Const cOR=\-cPRIMSEC_top
			data *^cOR_c
			Data *=cPRIMSEC
			Data *=cOR
			Data *=spacereq
		Const cXOR=\-cPRIMSEC_top
			data *^cXOR_c
			Data *=cPRIMSEC
			Data *=cXOR
			Data *=spacereq
		Const cCALLEX_primsec=\-cPRIMSEC_top
	Const cONEARG=\-coms_start
	Const cONEARG_top=\
		Const cRETURN=\-cONEARG_top
			data *^cRETURN_c
			Data *=cONEARG
			Data *=cRETURN
			Data *=spacereq
		Const cINC=\-cONEARG_top
			data *^cINC_c
			Data *=cONEARG
			Data *=cINC
			Data *=spacereq
		Const cDEC=\-cONEARG_top
			data *^cDEC_c
			Data *=cONEARG
			Data *=cDEC
			Data *=spacereq
		Const cINCST=\-cONEARG_top
			data *^cINCST_c
			Data *=cONEARG
			Data *=cINCST
			Data *=spacereq
		Const cDECST=\-cONEARG_top
			data *^cDECST_c
			Data *=cONEARG
			Data *=cDECST
			Data *=spacereq
		Const cNEG=\-cONEARG_top
			data *^cNEG_c
			Data *=cONEARG
			Data *=cNEG
			Data *=spacereq
		Const cNOT=\-cONEARG_top
			data *^cNOT_c
			Data *=cONEARG
			Data *=cNOT
			Data *=spacereq
		Const cSHL1=\-cONEARG_top
			data *^cSHL1_c
			Data *=cONEARG
			Data *=cSHL1
			Data *=spacereq
		Const cSHR1=\-cONEARG_top
			data *^cSHR1_c
			Data *=cONEARG
			Data *=cSHR1
			Data *=spacereq
		Const cSAR1=\-cONEARG_top
			data *^cSAR1_c
			Data *=cONEARG
			Data *=cSAR1
			Data *=spacereq
		Const cEXIT=\-cONEARG_top
			data *^cEXIT_c
			Data *=cONEARG
			Data *=cEXIT
			Data *=spacereq
	Const cCALL=\-coms_start
		data *^cCALL_c
		Data *=cCALL
		Data *=0
		Data *=spacereq
		data *^cCALLX_c
		Data *=cCALL
		Data *=x_callx_flag
		Data *=spacereq
	Const cCONDITIONS=\-coms_start
	Const cCONDITIONS_top=\
		Const cIF=\-cCONDITIONS_top
			data *^cIF_c
			Data *=cCONDITIONS
			Data *=cIF
			Data *=spacereq
		Const cELSEIF=\-cCONDITIONS_top
			data *^cELSEIF_c
			Data *=cCONDITIONS
			Data *=cELSEIF
			Data *=spacereq
		Const cELSE=\-cCONDITIONS_top
			data *^cELSE_c
			Data *=cCONDITIONS
			Data *=cELSE
			Data *=spacenotreq
		Const cENDIF=\-cCONDITIONS_top
			data *^cENDIF_c
			Data *=cCONDITIONS
			Data *=cENDIF
			Data *=spacenotreq
		Const cENDELSEIF=\-cCONDITIONS_top
			data *^cENDELSEIF_c
			Data *=cCONDITIONS
			Data *=cENDELSEIF
			Data *=spacenotreq
		Const cENDELSE=\-cCONDITIONS_top
			data *^cENDELSE_c
			Data *=cCONDITIONS
			Data *=cENDELSE
			Data *=spacenotreq
		Const cWHILE=\-cCONDITIONS_top
			data *^cWHILE_c
			Data *=cCONDITIONS
			Data *=cWHILE
			Data *=spacereq
		Const cENDWHILE=\-cCONDITIONS_top
			data *^cENDWHILE_c
			Data *=cCONDITIONS
			Data *=cENDWHILE
			Data *=spacenotreq
		Const cBREAK=\-cCONDITIONS_top
			data *^cBREAK_c
			Data *=cCONDITIONS
			Data *=cBREAK
			Data *=spacenotreq
		Const cCONTINUE=\-cCONDITIONS_top
			data *^cCONTINUE_c
			Data *=cCONDITIONS
			Data *=cCONTINUE
			Data *=spacenotreq
	Const cIMPORTLINK=\-coms_start
		const cIMPORT=Xfile_import_normal
			data *^cIMPORT_c
			Data *=cIMPORTLINK
			Data *=cIMPORT
			Data *=spacereq
		const cIMPORTX=Xfile_import_extern
			data *^cIMPORTX_c
			Data *=cIMPORTLINK
			Data *=cIMPORTX
			Data *=spacereq
	Const cSTARTFUNCTION=\-coms_start
		Const cFUNCTION=Xfile_function_tintern
			data *^cFUNCTION_c
			Data *=cSTARTFUNCTION
			Data *=cFUNCTION
			Data *=spacereq
		Const cFUNCTIONX=Xfile_function_extern
			data *^cFUNCTIONX_c
			Data *=cSTARTFUNCTION
			Data *=cFUNCTIONX
			Data *=spacereq
		Const cENTRY=Xfile_function_entry
			data *^cENTRY_c
			Data *=cSTARTFUNCTION
			Data *=cENTRY
			Data *=spacereq
		Const cENTRYRAW=Xfile_function_traw
			data *^cENTRYRAW_c
			Data *=cSTARTFUNCTION
			Data *=cENTRYRAW
			Data *=spacereq
	Const cENDFUNCTION=\-coms_start
		data *^cENDFUNCTION_c
		Data *=cENDFUNCTION
		Data *#1
		Data *=spacenotreq
	Const cEND=\-coms_start
		data *^cEND_c
		Data *=cEND
		Data *#1
		Data *=spacenotreq
	Const cRET=\-coms_start
		data *^cRET_c
		Data *=cRET
		Data *#1
		Data *=spacenotreq
	Const cINCLUDELINK=\-coms_start
		Const cINCLUDE=Xfile_include_normal
			data *^cINCLUDE_c
			Data *=cINCLUDELINK
			Data *=cINCLUDE
			Data *=spacereq
		Const cEINCLUDE=Xfile_include_extern
			data *^cEINCLUDE_c
			Data *=cINCLUDELINK
			Data *=cEINCLUDE
			Data *=spacereq
	Const cFORMAT=\-coms_start
		data *^cFORMAT_c
		Data *=cFORMAT
		Data *#1
		Data *=spacereq
#aftercall can be at function parameters but the get_img_vdata_dataReg() is set inside and codding must be done for not a big deal
	Const cDECLAREAFTERCALL=\-coms_start
	Const cDECLAREAFTERCALL_top=\
		Const cAFTERCALLIMPORT=\-cDECLAREAFTERCALL_top
			data *^cAFTERCALLIMPORT_c
			Data *=cDECLAREAFTERCALL
			Data *=cAFTERCALLIMPORT
			Data *=spacereq
		Const cAFTERCALL=\-cDECLAREAFTERCALL_top
			data *^cAFTERCALL_c
			Data *=cDECLAREAFTERCALL
			Data *=cAFTERCALL
			Data *=spacereq
	Const cMANIPULATEAFTERCALL=\-coms_start
	Const cMANIPULATEAFTERCALL_top=\
		Const cAFTERCALLENABLE=\-cMANIPULATEAFTERCALL_top
			data *^cAFTERCALLENABLE_c
			Data *=cMANIPULATEAFTERCALL
			Data *=cAFTERCALLENABLE
			Data *=spacenotreq
		Const cAFTERCALLDISABLE=\-cMANIPULATEAFTERCALL_top
			data *^cAFTERCALLDISABLE_c
			Data *=cMANIPULATEAFTERCALL
			Data *=cAFTERCALLDISABLE
			Data *=spacenotreq
	Const cCALLEX=\-coms_start
		data *^cCALLEX_c
		Data *=cCALLEX
		Data *=0
		Data *=spacereq
		data *^cCALLEXX_c
		Data *=cCALLEX
		Data *=x_callx_flag
		Data *=spacereq
	Const cLIBRARY=\-coms_start
		data *^cLIBRARY_c
		Data *=cLIBRARY
		Data *#1
		Data *=spacereq
	Const cHEX=\-coms_start
		data *^cHEX_c
		Data *=cHEX
		Data *#1
		Data *=spacereq
	Const cOVERRIDE=\-coms_start
		data *^cOVERRIDE_c
		Data *=cOVERRIDE
		Data *#1
		Data *=spacereq
	Const cORPHAN=\-coms_start
		data *^cORPHAN_c
		Data *=cORPHAN
		Data *#1
		Data *=spacereq
	Const cI3=\-coms_start
		data *^cI3_c
		Data *=cI3
		Data *#1
		Data *=spacenotreq
Const numberofcommands=(\-coms_start)/com_size
Const Error=\-coms_start

Data pointers#numberofcommands+1
Const compointersloc^pointers

Data pointersvars#numberofcommandsvars+1
Const compointersvarsloc^pointersvars

#at fn
const x_func_flag=0x80000000   #at def, varargs

#at ...call...
const x_callx_flag=0x80000000  #call a variable function import like functionx importx
const x_callg_flag=0x40000000  #skip aftercall

const call_ret_flag=0x20000000 #at call
const x_call_flag=0x10000000   #at setcall... . attention that at write_func is asking about callret and setcall does not have that

const x_call_flags=x_call_flag|x_callx_flag|x_callg_flag

#declare coresp
function commandSubtypeDeclare_to_typenumber(sd subtype,sd p_is_expand)
#these numbers will be used at getstruct directly
	if subtype=(cCONST)
		return (constantsnumber)
	endif
	div subtype (com_size)
	if subtype>=(xnumbers)
		if subtype>=(xvnumbers)
			sub subtype (xnumbers-totalmemvariables)
		else
			sub subtype (xnumbers)
		endelse
		set p_is_expand# (TRUE)
	else
		set p_is_expand# (FALSE)   #this, if typenumber is constant, atm is not used
	endelse
	return subtype
endfunction
#set errormsg to pointer error or return the find
Function getcommand(value pcontent,data psize,data ptrsubtype,data ptrerrormsg,data pointercommands)
	Data zero=0
	Data command#1
	Data result#1
	Data cursor#1
	Data true=TRUE

	Data dsz=dwsz

	valuex start#1;set start pcontent#
	Set cursor pointercommands#
	While cursor!=zero
		Data offset#1
		Set offset cursor#
		Add cursor dsz
		Set command cursor#
		Add cursor dsz
		Set ptrsubtype# cursor#

		Data spacebool#1
		Add cursor dsz
		Set spacebool cursor#

		#implement for Set[X]Call
		Char calldata="CALL"
		vStr call^calldata
		vstr xstr="X"
		vstr skipaftercall="G"
		value pointer#1;data sz#1

		ss extstr=NULL

		sd extbooldata=FALSE
		sv extbool^extbooldata
		sd intercursors=NULL
		set pointer start

		If command=(cPRIMSEC)
			Set extstr xstr
			set intercursors #pointer
		elseif command=(cCALL)
		vstr call_ret_str="RET"
			set extstr call_ret_str
			set intercursors #pointer
		Elseif command=(cSTARTFUNCTION)
			sd x_fn;setcall x_fn func_xfile(ptrsubtype#)
			if x_fn!=(Xfile_function_not_x)
				Set extstr xstr ##varargs
			endif
		elseif command=(cCALLEX)
			set extstr call_ret_str
			set intercursors #pointer
		endElseif

		SetCall result stringsatmemspc(pcontent,psize,offset,spacebool,extstr,extbool,intercursors)
		If extbooldata=true
		#here firstAndSecond part was recognized
			If command=(cPRIMSEC)
				if result=(TRUE)
				#setx
					or ptrsubtype# (x_call_flag|x_callx_flag)
					Return command
				else
					#here there was not a space
					setcall result stratmemspc(#pointer,#sz,skipaftercall,spacebool)
					if result=(TRUE)
						or ptrsubtype# (x_call_flag|x_callx_flag|x_callg_flag)
						set pcontent# pointer
						set psize# sz
						Return command
					endif
					#maybe is the deprecated ..xcall
					setcall result stratmemspc(#pointer,#sz,call,spacebool)
					if result=(TRUE)
						#or first byte at subcommand to recognize the xcall at two args
						or ptrsubtype# (x_call_flag|x_callx_flag)
						set pcontent# pointer
						set psize# sz
						Return command
					endif
				endelse
			Elseif result=(TRUE)
				If command=(cSTARTFUNCTION)
				#functionx/entry [x] , varargs
					#allow the command at 64, there is a check inside parsefunc, and for xfile better to know
					#sd for64;setcall for64 is_for_64()
					#if for64==(TRUE)
					or ptrsubtype# (x_func_flag)
					#endif
					return command
				else
				#call[ex][x]ret
					or ptrsubtype# (call_ret_flag)
					return command
				endelse
			endElseif
		elseIf result=true
		#here (first/onlyone)+-space was ok
			Return command
		elseif start!=pointer  ##here first was ok, but not extra part
			if command=(cPRIMSEC)
				setcall result stratmemspc(#pointer,#sz,skipaftercall,spacebool)
				if result=(TRUE)
					or ptrsubtype# (x_call_flag|x_callg_flag)
					set pcontent# pointer
					set psize# sz
					Return command
				endif
				#maybe is the deprecated ..call
				setcall result stratmemspc(#pointer,#sz,call,spacebool)
				if result=(TRUE)
					or ptrsubtype# (x_call_flag)
					set pcontent# pointer
					set psize# sz
					Return command
				endif
				#break #don't want to remember this when having something like addend command, and who will wrong here?
			else
			#if command=(cCALL)
			#if command=(cCALLEX)  #cSTARTFUNCTION is not coming here with intercursors=NULL
				setcall result stratmemspc(#pointer,#sz,skipaftercall,spacebool)
				if result=(TRUE)
					or ptrsubtype# (x_callg_flag)
					set pcontent# pointer
					set psize# sz
					Return command
				endif
			endelse
		endelseIf
		Add pointercommands dsz
		Set cursor pointercommands#
	EndWhile

	Char _unrecCom="Unrecognized command/declaration name."
	vStr unrecCom^_unrecCom
	Set ptrerrormsg# unrecCom
EndFunction



Function sortcommands(sv pointerscursor,sd nrofcomms,sd datacursor)
#it's that old strategy elseif will be only else if let unsorted, endelseif/endelse, maybe more
	sd i=0
#	Data sz#1
#	Data j#1
	Data dsize=dwsz
#	Data szval#1
#	Data ptrval#1
#	Data ptrvalstand#1
#	Data dataval#1

	While i<nrofcomms
#		SetCall sz strlen(datacursor#)
#		Set j i
#		Set ptrval pointerscursor
#		Set ptrvalstand pointerscursor
#		While zero<j
#			Sub ptrval dsize
#			Set dataval ptrval#
#			SetCall szval strlen(dataval#)
#			If szval>=sz
#				Set j zero
#			Else
#				Set ptrvalstand# dataval
#				Sub ptrvalstand dsize
#				Dec j
#			EndElse
#		EndWhile
#		Set ptrvalstand# datacursor
		set pointerscursor# datacursor
		Add pointerscursor dsize
		Add datacursor dsize
		Add datacursor dsize
		Add datacursor dsize
		Add datacursor dsize
		Inc i
	EndWhile
	Set pointerscursor# (NULL)
EndFunction

Function sortallcommands()
#put commands pointers at init
	vdata commandscursorini%comsloc
	vData pointerscursor%compointersloc
	Data comms=numberofcommands

	Call sortcommands(pointerscursor,comms,commandscursorini)

	vData datacursorini%cdataloc
	vData pointersvarscursor%compointersvarsloc
	Data variables=numberofcommandsvars
	Call sortcommands(pointersvarscursor,variables,datacursorini)
EndFunction
