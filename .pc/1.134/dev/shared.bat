

call ./dev/files.bat

ld -nostdlib -s %files% ./shared/action_dllmain.o --no-leading-underscore -shared -entry DllMain -o ./actionswf.dll -L./fix -lc --exclude-modules-for-implib %files_1%,%files_2%,%files_3%,%files_4%,%files_5%,%files_6%,%files_7%,%files_8%,%files_9%,./shared/action_dllmain.o