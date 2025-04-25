
::use Makefile
exit

cd ..

call dll.bat

cd example

g++ -o shared_c++_example.exe shared_c_example.c -L../lib -lactionswf

PATH=..\;%PATH%

shared_c++_example.exe