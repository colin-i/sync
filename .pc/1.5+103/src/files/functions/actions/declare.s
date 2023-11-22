
#err
function declare(sv pcontent,sd pcomsize,sd bool_64,sd subtype,sd parses)
	Data valsize#1
	Char sign#1
	#below also at virtual at get_reserve (with mask there)
	sd is_stack
	sd typenumber
	sd mask

	sd unitsize

	sd declare_typenumber
	sd is_expand
	setcall declare_typenumber commandSubtypeDeclare_to_typenumber(subtype,#is_expand)

	#still can be ok at nobits=No, let natural selection because pnobitsReg is implemented instead of datasecSize at writes for simplicity
	#if is_expand==(TRUE)
	#	if parses==(pass_init)
	#		call advancecursors(pcontent,pcomsize,pcomsize#)
	#		return (noerror)
	#	endif
	#endif

	sd xfile_decltype
	if declare_typenumber==(vintegersnumber)
		set is_stack (FALSE);set typenumber (integersnumber)
		if bool_64==(TRUE);set mask (datapointbit)
			if parses==(pass_init)
				set unitsize (qwsz)
			else
				set xfile_decltype (Xfile_decltype_longInt)
			endelse
		else;set mask 0
			if parses==(pass_init)
				set unitsize (dwsz)
			else
				set xfile_decltype (Xfile_decltype_longInt)
			endelse
		endelse
	elseif declare_typenumber==(vstringsnumber)
		set is_stack (FALSE);set typenumber (stringsnumber)
		if bool_64==(TRUE);set mask (datapointbit)
			if parses==(pass_init)
				set unitsize (qwsz)
			else
				set xfile_decltype (Xfile_decltype_longByte)
			endelse
		else;set mask 0
			if parses==(pass_init)
				set unitsize (dwsz)
			else
				set xfile_decltype (Xfile_decltype_longByte)
			endelse
		endelse
	elseif declare_typenumber==(valuesnumber)
		set is_stack (FALSE);set typenumber (integersnumber)
		if bool_64==(TRUE);set mask (valueslongmask)
			if parses==(pass_init)
				set unitsize (qwsz)
			else
				set xfile_decltype (Xfile_decltype_long)
			endelse
		else;set mask 0
			if parses==(pass_init)
				set unitsize (dwsz)
			else
				set xfile_decltype (Xfile_decltype_long)
			endelse
		endelse
	else
		setcall typenumber stackfilter(declare_typenumber,#is_stack)
		if parses==(pass_init)
			if is_stack==(TRUE)
				if typenumber==(stringsnumber)
					set unitsize 0
				else
					call advancecursors(pcontent,pcomsize,pcomsize#)
					return (noerror)
				endelse
			else
				if typenumber!=(charnumber)
					if typenumber!=(constantsnumber)
						set unitsize (dwsz)
					endif
				else
					set unitsize (bsz)
				endelse
			endelse
		else
			if is_stack==(TRUE)
				#must be at the start
				call entryscope_verify_code()

				#xfile part
				if typenumber==(valuesinnernumber)
					set xfile_decltype (Xfile_decltype_long)
				elseif typenumber==(integersnumber)
					set xfile_decltype (Xfile_decltype_longInt)
				else #(stringsnumber)
					set xfile_decltype (Xfile_decltype_longByte)
				endelse
			else
				#xfile part
				if typenumber==(constantsnumber)
					set xfile_decltype (Xfile_decltype_const)
				elseif typenumber==(charnumber)
					set xfile_decltype (Xfile_decltype_byte)
				elseif typenumber==(integersnumber)
					set xfile_decltype (Xfile_decltype_int)
				else #(stringsnumber)
					set xfile_decltype (Xfile_decltype_intByte)
				endelse
			endelse
		endelse
		set mask 0
	endelse

	sd err
	sd relocbool=FALSE;sd dataxrel
	setcall err getsign(pcontent#,pcomsize#,#sign,#valsize,typenumber,is_stack,#relocbool,#dataxrel)
	if err==(noerror)
		if parses==(pass_init)
			if typenumber==(constantsnumber)
				setcall err addtolog_withchar_ex_atunused(pcontent#,valsize,(log_declare))
				if err==(noerror)
					if sign==(pointersigndeclare)
						call advancecursors(pcontent,pcomsize,pcomsize#)
						return (noerror)
					endif
					setcall err dataassign(pcontent,pcomsize,sign,valsize,typenumber,(NULL),mask,relocbool) #there are 3 more argument but are not used
					#                                                                            since %%|
				endif
			else
				setcall err vars_log_prepare(pcontent#,valsize)
				if err==(noerror)
					if unitsize==0
					#ss?
						if sign!=(assignsign)
							call advancecursors(pcontent,pcomsize,pcomsize#)
							return (noerror)
						endif
						#ss =% ""/x/{}
					else
					#search for data%  with R_X86_64_64
						if relocbool==(TRUE)
							if mask==0
							#data str
							#strs are without ""
								vdata is_64_and_pref_is_rx866464%p_elf64_r_info_type
								if is_64_and_pref_is_rx866464#==(R_X86_64_64)
									set unitsize (qwsz)
								endif
							endif
						endif
					endelse
					setcall err dataassign(pcontent,pcomsize,sign,valsize,typenumber,#unitsize,mask,relocbool,dataxrel,is_stack) #there is 1 more argument but is not used
					#                                                                               since %%|
					if is_expand==(FALSE)
						sd pdataReg%%ptr_dataReg
						add pdataReg# unitsize
					else
						sd pnobitsReg%ptrdataSize
						add pnobitsReg# unitsize
					endelse
				endif
			endelse
		else
			setcall err xfile_add_declare_if(xfile_decltype,is_stack,is_expand,pcontent#,valsize,sign,relocbool,dataxrel)
			if err==(noerror)
				if typenumber==(constantsnumber)
					if sign!=(pointersigndeclare)
						setcall err xfile_add_char_if((Xfile_declmode_value))
						if err==(noerror)
							call advancecursors(pcontent,pcomsize,pcomsize#)
							return (noerror)
						endif
					endif
				elseif is_expand==(TRUE)
					if sign!=(reservesign)
						return "Virtual declarations can have only the reserve sign."
					endif
				endelseif
				SetCall err dataassign(pcontent,pcomsize,sign,valsize,typenumber,(NULL),mask,relocbool,dataxrel,is_stack,is_expand)
			endif
		endelse
	endif
	return err
endfunction
