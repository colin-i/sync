
format elfobj64

function file()
	valuex path#1
	valuex lines#1
	datax a#1
endfunction

function line()
	datax a#1
endfunction

entry main(sd *,sd c)
sd *#1
sd n#2
value *=0x77
value test#1;value test2#1;data a#1
sv aux^test
value auxdata^test

set test:file.a 4
set test:line.a 4
set n:main.n 4
set n:main.c 4

#not this right now
#set aux#:file.a 4
set auxdata#:file.a 4

set aux#:file.path 2
set aux#:file.lines 3
add test test2
return test