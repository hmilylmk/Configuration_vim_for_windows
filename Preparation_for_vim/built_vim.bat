@echo off
REM Run this batch file from any directory to build gvim.exe and vim.exe.
REM But first edit the paths and Python version number.

REM --- Specify Vim /src folder ---
set VIMSRC=G:\vim81\src
REM --- Add MinGW /bin directory to PATH ---
PATH = G:\mingw64\bin;%PATH%
REM --- Also make sure that PYTHON, PYTHON_VER below are correct. ---

REM get location of this batch file
set WORKDIR=%~dp0
set LOGFILE=%WORKDIR%log.txt

echo Work directory: %WORKDIR%
echo Vim source directory: %VIMSRC%

REM change to Vim /src folder
cd /d %VIMSRC%

REM --- Build GUI version (gvim.exe) ---
echo Building gvim.exe ...
REM The following command will compile with both Python 2.7 and Python 3.3
mingw32-make.exe -f Make_ming.mak ARCH=x86-64 MBYTE=yes IME=yes GIME=yes DYNAMIC_IME=yes CSCOPE=yes DEBUG=no LUA="G:/Lua" DYNAMIC_LUA=yes LUA_VER=53 PYTHON="E:/Python27" PYTHON_VER=27 DYNAMIC_PYTHON=yes PYTHON3="E:/Python37" PYTHON3_VER=37 DYNAMIC_PYTHON3=yes FEATURES=HUGE GUI=yes gvim.exe > "%LOGFILE%"

REM --- Build console version (vim.exe) ---
echo Building vim.exe ...
REM The following command will compile with both Python 2.7 and Python 3.3
mingw32-make.exe -f Make_ming.mak ARCH=x86-64 MBYTE=yes IME=yes GIME=yes DYNAMIC_IME=yes CSCOPE=yes DEBUG=no LUA="G:/Lua" DYNAMIC_LUA=yes LUA_VER=53 PYTHON="E:/Python27" PYTHON_VER=27 DYNAMIC_PYTHON=yes PYTHON3="E:/Python37" PYTHON3_VER=37 DYNAMIC_PYTHON3=yes FEATURES=HUGE GUI=no vim.exe >> "%LOGFILE%"

echo Moving files ...
move gvim.exe "%WORKDIR%"
move vim.exe "%WORKDIR%"


echo Cleaning Vim source directory ...
REM NOTE: "mingw32-make.exe -f Make_ming.mak clean" does not finish the job
IF NOT %CD%==%VIMSRC% GOTO THEEND
IF NOT EXIST vim.h GOTO THEEND
IF EXIST pathdef.c DEL pathdef.c
IF EXIST obj\NUL      RMDIR /S /Q obj
IF EXIST objx86-64\NUL  RMDIR /S /Q objx86-64
IF EXIST gobj\NUL     RMDIR /S /Q gobj
IF EXIST gobjx86-64\NUL RMDIR /S /Q gobjx86-64
IF EXIST gvim.exe DEL gvim.exe
IF EXIST vim.exe  DEL vim.exe
:THEEND

pause