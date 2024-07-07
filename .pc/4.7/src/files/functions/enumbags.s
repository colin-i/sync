

#err
Function enumbags(data declare)
	Data true=TRUE

	Data containersbegin%containersbegin
	Data containerssize=containerssize
	Data pointer#1
	Data size#1
	Data dsz=dwsz
	Data maxalloc#1
	Data noerr=noerror

	Data value#1
	Data zero=0

	Set pointer containersbegin
	Set size containerssize
	While size>zero
		Set maxalloc pointer#
		Add pointer dsz
		Sub size dsz
		If declare==true
			Data err#1
			SetCall err memoryalloc(maxalloc,pointer)
			If err!=noerr
				Return err
			EndIf
		Else
			Set value pointer#
			If value!=zero
				Call free(value)
			EndIf
		EndElse
		Add pointer dsz
		Sub size dsz
		Add pointer dsz
		Sub size dsz
	EndWhile
	Return noerr
EndFunction

#no return
Function freeclose()
	Data value#1
	Data zero=0

	Call enumbags(zero)

	Data negative=-1

	Data ptrfileout%ptrfileout
	Set value ptrfileout#
	If value!=negative
		Call close(value)
	EndIf

	data ptrlogfile%ptrlogfile
	Set value ptrlogfile#
	If value!=negative
		Call close(value)
	EndIf

	#here if allocerrormsg was a submessage(included in sprintf)
	#here at some main msgerrexits
	call clearmessage()

	sd p_safecurrentdirtopath%p_safecurrentdirtopath
	if p_safecurrentdirtopath#!=(NULL)
		call free(p_safecurrentdirtopath#)
	endif

	call platform_free()
EndFunction

Function msgerrexit(data msg)
	Call Message(msg)
	call errexit()
EndFunction

Function errexit()
	Call freeclose()
	call errorexit()
EndFunction

function errorexit()
	Call exit(-1)
endfunction

function exitMessage(ss s)
	call Message(s)
	call errorexit()
endfunction