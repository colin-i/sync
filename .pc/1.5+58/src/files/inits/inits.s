


#fileformat#
#file format variable

Set fileformat pe_exec
Set formatdefined 0

#set default imagebase for data
Data default_imagebase=pe_imagebase
Set imagebaseoffset default_imagebase

#start of data, here and at format command
Set startofdata page_sectionalignment

Set object false
#fileformat#

#for function in function rule
Set innerfunction false

Set programentrypoint zero


#sort the commands
Call sortallcommands()


#the detailed functions and entry point informations
#main alloc error msg
Chars entrystartfile#shortstrsize
Str ptrentrystartfile^entrystartfile
Data entrylinenumber#1

Set fnavailable one


#implibsstarted for closing at the end and for import parts; is here because 0 bytes src is something and asking for this at end
Set implibsstarted false

#fn info text is at preferences

#pref
sd prefix
setcall prefix prefix_bool()
set prefix# 0

set dummyEntryReg 0
call add_ref_to_sec(ptrdummyEntry,0,(dummy_mask),(NULL),0)

sd var
setcall var function_in_code()
set var# 0

#64bit
#is init , is tested at any import and is set TRUE/FALSE only at elfobj... syntax
sd p_is_for_64_value;setcall p_is_for_64_value p_is_for_64();set p_is_for_64_value# (FALSE)
#call stack64_op_set_get((TRUE),(FALSE))
call val64_init()

#afterCall
vdata g_e_b_p#1;setcall g_e_b_p global_err_pBool();set g_e_b_p# (FALSE)

set warn_hidden_whitespaces_times 0

sd convention_64
setcall convention_64 p_neg_is_for_64()

ss init_argmasks
setcall init_argmasks argmasks()
set init_argmasks# 0

if includedir==(TRUE)
	set fileendchar (log_fileend)
else
	set fileendchar (log_fileend_old)
endelse

#this is init at start because we don't want to compare if 64 every time
sd rel64_blankinit%p_elf64_r_info_type
set rel64_blankinit# (R_X86_64_32)

set real_exit_end (FALSE)

sd el_or_e=FALSE

#needing also at pass call and pass write
set functionTagIndex 0

call resetisimm()

#this is init at main.s and used after that    set datasecSize 0