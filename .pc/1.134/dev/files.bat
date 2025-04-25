
set files_src=./src/
set files_export=

set /p content=<./dev/f1.txt
call :sub1 %content%
goto go
:sub1
if "%1"=="" exit /b
set files_export=%files_export% "%files_src%%1.o"
shift
goto :sub1
:go

set /a iter=1
set /p content=<./dev/f2.txt
call :sub2 %content%
goto go2
:sub2
if "%1"=="" exit /b
set files_%iter%="%files_src%%1.o"
set /a iter=%iter%+1
shift
goto :sub2
:go2
set files=%files_export% %files_1% %files_2% %files_3% %files_4% %files_5% %files_6% %files_7% %files_8% %files_9%
