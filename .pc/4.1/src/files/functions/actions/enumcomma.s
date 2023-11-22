
#e
function writevar(data ptrvalue,data unitsize,data relindex,data stack,data rightstackpointer)
	data err#1
	data noerr=noerror
	Data ptrrelocbool%ptrrelocbool
	data true=TRUE
	data false=FALSE
	data ptrobject%ptrobject

	if ptrobject#==1
		If ptrrelocbool#==true
			if stack==false
				#data
				Data ptraddresses%ptraddresses
				Data relocoff=0
				SetCall err adddirectrel_base(ptraddresses,relocoff,relindex,ptrvalue#)
			else
				#code
				data ptrextra%ptrextra
				data stackoff=rampadd_value_off
				setcall err adddirectrel_base(ptrextra,stackoff,relindex,ptrvalue#)
			endelse
			If err!=noerr
				Return err
			EndIf
		EndIf
	endif
	if stack==false
		data ptrdatasec%ptrdatasec
		SetCall err addtosec(ptrvalue,unitsize,ptrdatasec)
	else
		setcall err addtocodeforstack(ptrvalue#,rightstackpointer)
	endelse
	return err
endfunction

const fndecandgroup=1
#er
Function enumcommas(data ptrcontent,data ptrsize,data sz,data fndecandgroupOrpush,data typenumber,data stack,sd hex)
	Data zero=0
	Data argsize#1
	Chars comma=","
	Data err#1
	Data noerr=noerror
	Data content#1
	Data csv#1
	Data csvloop=1

	Data true=TRUE
	Data false=FALSE
	Data sens#1
	Data forward=FORWARD
	Data backward=BACKWARD

	Set csv csvloop
	Set content ptrcontent#

	Data fnnr=functionsnumber
	If fndecandgroupOrpush==true
		If typenumber==fnnr
			Data stackoffset#1
			Set stackoffset zero
			Data ptrstackoffset^stackoffset
		Else
			Data bSz=bsz
			Data dwSz=dwsz
			Data unitsize#1
			Data charsnr=charsnumber
			If typenumber==charsnr
				Set unitsize bSz
			Else
				Set unitsize dwSz
			EndElse
		EndElse
		Set sens forward
	Else
		Data storecontent#1
		Add content sz
		Set ptrcontent# content
		Set storecontent content
		Set sens backward
	EndElse
	While csv==csvloop
		If fndecandgroupOrpush==true
			SetCall argsize valinmemsens(content,sz,comma,sens)
			#allow (x,    y,   z) spaces
			sd sizeaux
			set sizeaux ptrsize#
			call spaces(ptrcontent,ptrsize)
			sub sizeaux ptrsize#
			sd argumentsize
			set argumentsize argsize
			sub argumentsize sizeaux
			#
			If typenumber==fnnr
				SetCall err fndecargs(ptrcontent,ptrsize,argumentsize,ptrstackoffset)
				If err!=noerr
					Return err
				EndIf
			Else
				Data value#1
				Data ptrvalue^value
				SetCall err parseoperations(ptrcontent,ptrsize,argumentsize,ptrvalue)
				If err!=noerr
					Return err
				EndIf
				if hex==(not_hexenum)
					data dataind=dataind
					setcall err writevar(ptrvalue,unitsize,dataind,stack,zero)
					If err!=noerr
						Return err
					EndIf
				else
					sd ptrcodesec%ptrcodesec
					setcall err addtosec(ptrvalue,unitsize,ptrcodesec)
					If err!=noerr
						Return err
					EndIf
				endelse
			EndElse
		Else
			#push
			call nr_of_args_64need_count()
			sd delim
			set delim comma
			if sz!=0
				ss test
				set test content
				dec test
				chars quot="\""
				if test#==quot
					set delim quot
					#look later at escapes, here only at the margins
					ss c
					sd s
					set c content
					set s sz
					set argsize s
					#case "abc,"
					dec test
					if test#==comma
						sub c 2
						sub s 2
					endif
					#
					sd len
					sd loop=1
					while loop==1
						#here the sens is backward and ," or (" represents the end of the string
						SetCall len valinmemsens(c,s,comma,sens)
						mult len -1
						Call advancecursors(#c,#s,len)
						if c#==quot
							set loop 0
						else
							#here the string ".." is in a good condition when quotes_forward was called at fn(...)
							Call advancecursors(#c,#s,-1)
						endelse
					endwhile
					sub argsize s
				endif
			endif
			if delim==comma
				SetCall argsize valinmemsens(content,sz,comma,sens)
			endif
			
			Data negvalue#1
			Set negvalue zero
			Sub negvalue argsize
			Call advancecursors(ptrcontent,ptrsize,negvalue)
			Data ptrargsize^argsize
			SetCall err argument(ptrcontent,ptrargsize,zero,backward)
			If err!=noerr
				Return err
			EndIf
		EndElse
		Sub sz argsize
		If sz!=zero
			Dec sz
			Call advancecursors(ptrcontent,ptrsize,sens)
			Set content ptrcontent#
		Else
			Set csv zero
		EndElse
	EndWhile
	If fndecandgroupOrpush==false
		Set ptrcontent# storecontent
	EndIf
	Return noerr
EndFunction