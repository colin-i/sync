
::use Makefile
exit

cd ..

call dll.bat

cd example

gcc -o shared_c_example.exe shared_c_example.c -L../lib -lactionswf

PATH=..\;%PATH%

shared_c_example.exe