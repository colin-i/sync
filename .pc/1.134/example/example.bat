
::use Makefile
exit

cd ..

call dev\lib.bat
call dev\build.bat
call 64\build.bat

cd example

o example.oc
objcopy --input-target=elf32-i386 example.o --output-target=elf64-x86-64 exampleX.o

cd ..

set objects=./example/exampleX.o

set program=./example/example.exe

set entrypoint=example_main

call ./dev/link.bat

cd example

example.exe