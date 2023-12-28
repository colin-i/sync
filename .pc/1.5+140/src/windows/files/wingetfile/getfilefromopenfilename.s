
#OPENFILENAME
Const OFN_FILEMUSTEXIST=0x1000
Const OFN_PATHMUSTEXIST=0x0800

Const ofnFlags=OFN_FILEMUSTEXIST|OFN_PATHMUSTEXIST

Str ofnfiltermemvalue#1

setcall path_free memalloc(flag_max_path)
if path_free=(NULL)
	#memalloc has message
	call errexit()
endif
set path_free# 0

Include "./getfilefromopenfilename/lpstrFilter.s"


Data ofnlStructSize=0x58
Data *ofnhwndOwner=0
Data *ofnhInstance=0
Str ofnfiltermem#1
Set ofnfiltermem ofnfiltermemvalue

Data *ofnlpstrCustomFilter=0
Data *ofnnMaxCustFilter=0
Data *ofnnFilterIndex=0
Str ofnlpstrFile#1
Set ofnlpstrFile path_free

Data ofnnMaxFile#1
Set ofnnMaxFile flag_max_path
Data *ofnlpstrFileTitle=0
Data *ofnnMaxFileTitle=0
Data *ofnlpstrInitialDir=0

Data *ofnlpstrTitle=0
Data *ofnFlags=ofnFlags
Data *ofnnFileOffset=0
Data *ofnnFileExtension=0
Data *ofnlpstrDefExt=0

Data *ofnlCustData=0
Data *ofnlpfnHook=0
Data *ofnlpTemplateName=0
#if (_WIN32_WINNT >= 0x0500)
Data *ofnpvReserved=0

Data *ofndwReserved=0
Data *ofnFlagsEx=0
#endif

Data OFNfile^ofnlStructSize
Data openfilenameresult#1
SetCall openfilenameresult GetOpenFileName(OFNfile)

Call free(ofnfiltermem)

If openfilenameresult=zero
	Call msgerrexit("No file selected or an error occurs.")
EndIf
