
const dword=4

function alloc(sd p)
	sd er
	setcall er alloc_throwless(p)
	if er=(NULL)
		ret
	endif
	call erExit(er)
endfunction

function ralloc(sv p,sd sz)
	sd er
	setcall er ralloc_throwless(p,sz)
	if er=(NULL)
		ret
	endif
	call erExit(er)
endfunction

function addtocont(sv cont,ss s,sd sz)
	#knowing ocompiler maxvaluecheck
	sd size=dword
	add size sz
	call ralloc(cont,size)
	sd mem
	set mem cont#
	add cont :
	add mem cont#d^
	sub mem sz
	call memcpy(mem,s,sz)
	sub mem (dword)
	set mem# sz
	#sd oldsize;set oldsize cont#d^;sd size=dword;add size sz;call ralloc(cont,size);add cont (dword);add oldsize cont#;set oldsize# sz;add oldsize (dword);call memcpy(oldsize,s,sz)
endfunction
function addtocont_rev(sv cont,ss s,sd sz)
	sd size=dword
	add size sz
	call ralloc(cont,size)
	sd mem
	set mem cont#
	add cont :
	add mem cont#d^
	sub mem (dword)
	set mem# sz
	sub mem sz
	call memcpy(mem,s,sz)
	#sd oldsize;set oldsize cont#d^;sd size=dword;add size sz;call ralloc(cont,size);add cont (dword);add oldsize cont#;call memcpy(oldsize,s,sz);add oldsize sz;set oldsize# sz
endfunction
function adddwordtocont(sv cont,sd the_dword)
	call ralloc(cont,(dword))
	sd pos=-dword
	add pos cont#
	add cont :
	add pos cont#d^
	set pos# the_dword
endfunction
