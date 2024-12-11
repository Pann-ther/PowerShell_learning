@echo off

rem configuration d'acces au repertoire pour User1
if "%USERNAME%"=="User1" goto :User1

:u1
net use O: \\WS1\CD1
net use P: \\WS1\CD2
net use Q: \\WS2\SRV
start %SystemRoot%\system32\calc.exe
start %SystemRoot%\system32\notepad.exe

goto :end

rem configuration d'acces au repertoire pour User2
if "%USERNAME%"=="User2" goto :u2

:u2
net use I: \\WS1\CD1
net use J: \\WS1\CD2
net use K: \\WS2\SRV
start %SystemRoot%\system32\calc.exe
start %SystemRoot%\system32\notepad.exe

goto :end

echo on
:end
