o.exe "shared/action_dllmain.s"

set files_src=./src/

set /p content=<./dev/f1.txt
call :sub1 %content%
goto go
:sub1
if "%1"=="" exit /b

o.exe %files_src%%1.s

shift
goto :sub1
:go

set /p content=<./dev/f2.txt
call :sub1 %content%
