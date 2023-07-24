
const variable_convention=lin_convention

#err
function prefextra(ss prefpath,sd ptrpreferencessize,sd ptrpreferencescontent,ss scrpath)
	sd err
	setcall err prefextra_helper(prefpath,ptrpreferencessize,ptrpreferencescontent,scrpath)
	if err!=(noerror)
		Call Message(err)
	endif
	return err
endfunction
#err
function prefextra_helper(ss prefpath,sd ptrpreferencessize,sd ptrpreferencescontent,ss scrpath)
	sd err
	sd s2;setcall s2 strlen(prefpath)
	sd mem
	sd a

	#first verify in home
	ss homestr="HOME"
	ss envhome
	setcall envhome getenv(homestr)
	if envhome!=(NULL)
		sd s1;sd s3=2
		setcall s1 strlen(envhome);add s3 s1;add s3 s2
		setcall err memoryalloc(s3,#mem)
		if err==(noerror)
			call memtomem(mem,envhome,s1)
			ss p;set p mem;add p s1;set p# (asciislash);inc p
			call memtomem(p,prefpath,s2);add p s2;set p# (NULL)
			setcall a access(mem,(F_OK))
			if a==0
				SetCall err file_get_content_ofs(mem,ptrpreferencessize,ptrpreferencescontent,(NULL))
				if err==(noerror)
					call free(mem)
					return (noerror)
				endif
				call safeMessage(err)  #openfile has alloc err msg
			endif
			call free(mem)
		else
			return err
		endelse
	else
		call Message("Getenv error on HOME.")
	endelse

	#second verify in etc, more at Makefile about etcinclude
	sd size;setcall size strlen(scrpath)
	include "../../etcinclude.s"
	if size>etchelper
		sd test;set test scrpath
		add test size
		sub test etchelper
		sd cmp;setcall cmp memcmp(etc_helper,test,etchelper) #an example when testing from src folder, is not usr/bin/o / bin/o
		if cmp==0
			sub size etchelper
			sd sz=3+1+1
			sd allsize;set allsize size
			add allsize sz
			add allsize s2
			setcall err memoryalloc(allsize,#mem)
			if err==(noerror)
				call memtomem(mem,scrpath,size)
				set scrpath mem
				add scrpath size
				call memtomem(scrpath,"etc/",(3+1))
				add scrpath (3+1)
				call memtomem(scrpath,prefpath,s2)
				add scrpath s2
				set scrpath# (NULL)
				setcall a access(mem,(F_OK))
				if a==0
					SetCall err file_get_content_ofs(mem,ptrpreferencessize,ptrpreferencescontent,(NULL)) #openfile has alloc err msg
					if err==(noerror)
						call free(mem)
						return (noerror)
					endif
					Call safeMessage(err)  #openfile has alloc err msg
				endif
				call free(mem)
			else
				return err
			endelse
		endif
	endif

	call Message("No preferences file found in etc.")

	return "No preferences file found in HOME. The file is here: https://raw.githubusercontent.com/colin-i/o/master/.ocompiler.txt"
endfunction
