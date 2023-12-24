
#note that multiple calls on aftercall are tolerated and the next calls will use the last aftercall(can be used in a code strategy with multiple functions)

const aftercalldeclaresize=1

if comsize=0;set errormsg "AfterCall variable name expected."
else
	setcall errormsg xfile_add_char_if((Xfile_aftercall))
	if errormsg=(noerror)
		vstr ac_store_c#1;data ac_store_s#1
		data acsym_value#1;data acsym_size#1;data acsym_shndx#1
		sd g_e_p;setcall g_e_p global_err_p()
		if subtype=(cIMPORTAFTERCALL)
			If object=(FALSE);set errormsg "ImportAfterCall is used at objects."
			else
				set ac_store_c content;set ac_store_s comsize
				set acsym_value 0;set acsym_size (sym_with_size);set acsym_shndx (NULL)
				setcall errormsg xfile_add_base_if((Xfile_aftercall_import),content,comsize)
				call advancecursors(pcontent,pcomsize,comsize)
			endelse
		else
		#(cAFTERCALL)
			setcall errormsg xfile_add_char_if((Xfile_aftercall_declare))
			if errormsg=(noerror)
				sd ac_current_data
				setcall ac_current_data get_img_vdata_dataReg()  #this must be before addtosec
				SetCall errormsg addtosec(#null,(aftercalldeclaresize),ptrdatasec)
				if errormsg=(noerror)
					If object=(FALSE)
						set g_e_p# ac_current_data
					else
						set acsym_value ac_current_data;set acsym_size 0;set acsym_shndx (dataind)
					endelse
					#size 0 test is above
					if content#!=(unrefsign)
						SetCall errormsg entryvarsfns(content,comsize)
						if errormsg=(noerror)
							setcall errormsg xfile_add_base_if((Xfile_declfeature_normal),content,comsize)
							if errormsg=(noerror)
								set ac_store_c content;set ac_store_s comsize
								SetCall errormsg addaref(ac_current_data,pcontent,pcomsize,comsize,(charnumber),(dummy_mask))
							endif
						endif
					else
						#since aftercall(activate/clear)
						call stepcursors(pcontent,pcomsize)
						set ac_store_c (NULL);set ac_store_s 0
						#              ok not "", is content!=null once and inside that libc memcpy
						setcall errormsg xfile_add_base_if((Xfile_declfeature_unref),content,comsize)
						call advancecursors(pcontent,pcomsize,comsize)
					endelse
				endif
			endif
		endelse
		if errormsg=(noerror)
			#set g_e_b_p# (TRUE)
			if object=(TRUE)
				set g_e_p# tableReg
				if p_is_for_64_value#=(TRUE)
					div g_e_p# (elf64_dyn_d_val_syment)
				else
					div g_e_p# elf32_dyn_d_val_syment
				endelse
				#adding at current names reg the content lenghting comsize
				SetCall errormsg elfaddstrszsym(ac_store_c,ac_store_s,acsym_value,acsym_size,(STT_NOTYPE),(STB_GLOBAL),acsym_shndx,ptrtable)
				#can be weak at linux but windows needs global and we agreed imports are global
			endif
		endif
	endif
endelse
