
If innerfunction==true
	Char finferr="There is already another function started."
	Str ptrfinf^finferr
	Set errormsg ptrfinf
ElseIf programentrypoint!=codesecReg
	Char funcafterentry="Unavailable FUNCTION/ENTRY[...] statement; The start address was at File: %s; Line: %s."
	Str fnafteren^funcafterentry

	call dwtomem(entrylinenumber,uint32s)
	SetCall allocerrormsg printbuf(fnafteren,ptrentrystartfile,uint32s,0)
	If allocerrormsg==null
		Call errexit()
	EndIf
	Set errormsg allocerrormsg
Else
	sd varargs;set varargs subtype
	and varargs (x_func_flag)
	and subtype (~x_func_flag)

	if subtype==(cENTRY);set el_or_e (TRUE)
	elseif subtype==(cENTRYRAW);set el_or_e (TRUE)
	else;set el_or_e (FALSE);endelse
	If el_or_e==(TRUE)
		#Data referencebit=referencebit
		#Set objfnmask referencebit
		if parses==(pass_write)
			set fnavailable two
		endif
	Else
		#Set objfnmask null
		Set innerfunction true
	EndElse
	if errormsg==(noerror)
		Data declarefn=declarefunction
		SetCall errormsg parsefunction(pcontent,pcomsize,declarefn,subtype,el_or_e,varargs)
	endif
EndElse
