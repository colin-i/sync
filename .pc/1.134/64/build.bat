
::this was used in ocompiler < 1.4 only
exit

set files_src=src\

goto go
:sub1
if "%1"=="" exit /b
call :sub2 %files_src%%1
shift
goto :sub1

:sub2
objcopy --input-target=elf32-i386 "%1.o" --output-target=elf64-x86-64 "%1X.o"
del "%1.o"
move "%1X.o" "%1.o"
exit /b

:go

set /p content=<./dev/f1.txt
call :sub1 %content%
set /p content=<./dev/f2.txt
call :sub1 %content%
call :sub2 shared\action_dllmain
