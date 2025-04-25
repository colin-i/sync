
::must have the "objects", example : set objects=./example/example.o
::and the "program" variable, example : set program=./example/example.exe
::"entrypoint" is the main function : set entrypoint=example_main
::     like the one in the example folder

call ./dev/files.bat
ld -nostdlib -s -e %entrypoint% -o %program% %objects% %files% -L"./fix" -lc