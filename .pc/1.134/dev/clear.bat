
set /p content=<./dev/f1.txt
call :sub1 %content%
goto go
:sub1
if "%1"=="" exit /b

del "src\\%1.o"

shift
goto :sub1
:go

set /p content=<./dev/f2.txt
call :sub1 %content%

del "fix\\libc.a"
del "lib\\libactionswf.a"
del "shared\\action_dllmain.o"