
format elfobj64

function b()
data a#1
endfunction

entry main()

vstr a="qwer"

return 2
inc #a:b.a
inc #a
incst #b.a
dec a
decst a
neg a
not a
shl a
shr a
sar b.a
exit 3
return "asdf"
return main.a#:a
return b
