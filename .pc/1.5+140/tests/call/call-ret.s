
format elfobj64

function a()
endfunction

entry main()

sv b
hex 144;call a()
hex 144;callex a b 2
hex 144;callret a()
hex 144;callexret a b 2
