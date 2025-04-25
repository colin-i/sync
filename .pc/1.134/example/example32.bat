
::use Makefile
exit

gcc change_format.c -o change_format.exe

change_format.exe "Format ElfObj;#"
cd ..

call dev\lib.bat
call dev\build.bat

cd example
change_format.exe "Format ElfObj64"

o example32.oc

cd ..

set objects=./example/example32.o

set program=./example/example32.exe

set entrypoint=example_main

call ./dev/link.bat

cd example

example32.exe