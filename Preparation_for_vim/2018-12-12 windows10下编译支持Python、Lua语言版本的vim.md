2018-12-12 windows10下编译支持Python、Lua语言版本的vim



1、首先下载 MinGW 64位版本。

	MinGW64版本下载地址：https://sourceforge.net/projects/mingw-w64/files/

​	下载完了解压直接可用

2、下载vim最新版本的源码文件。

​	![1544619901147](G:\workspace\Github\Configuration_vim_for_windows\1544619901147.png)

​	用Git bash cd 到想要下载vim源码的目录

	git clone https://github.com/vim/vim

​	等待源码下载完成

3、下载Lua语言的库文件和bin文件。

	lua-5.3.4_Win64_bin.zip文件下载地址：https://sourceforge.net/projects/luabinaries/files/5.3.4/Tools%20Executables/lua-5.3.4_Win64_bin.zip/download

​	lua-5.3.4_Win64_dllw6_lib.zip文件下载地址https://sourceforge.net/projects/luabinaries/

​	将两个zip文件中的内容解压到你想解压的目录下。例如G:\Lua\

​	![1544620714833](G:\workspace\Github\Configuration_vim_for_windows\1544620714833.png)

4、下载Python版本2.7和3.X版本并安装好。

	Python各版本下载地址：https://www.python.org/downloads/windows/

	可以安装到任意你想安装到的位置

5、准备开始编译支持Lua、Python语言的vim。

	首先下载可用的windows下的vim版本，安装至你想安装的文件夹。例如G:\vim\vim81

	因为编译只编译gvim.exe和vim.exe两个文件

	在上面的G:\vim\vim81目录下创建一个built_vim.bat文件，将以下代码复制到文件中，双击运行，会自动编			译好。

@echo off
REM Run this batch file from any directory to build gvim.exe and vim.exe.
REM But first edit the paths and Python version number.

REM --- 设置 Vim /src 源码文件的路径 ---
set VIMSRC=G:\vim81\vim\src
REM --- 添加 MinGW \bin 路径到 PATH ---
PATH = G:\mingw64\bin;%PATH%

REM --- 获得脚本文件当前运行的路径 ---
set WORKDIR=%~dp0
set LOGFILE=%WORKDIR%log.txt

echo Work directory: %WORKDIR%
echo Vim source directory: %VIMSRC%

REM --- cd到 Vim /src 源码文件夹所在路径下 ---
cd /d %VIMSRC%

REM --- Build GUI 版本的vim (gvim.exe) ---
echo Building gvim.exe ...
REM --- 下面的命令将会编译带有Lua5.3、Python2.7和Python3.7版本的gvim，64位机器一定要带ARCH=x86-64参数，不然会报错。相应的lua、python文件目录需要修改成上面步骤中安装相应的目录 ---
mingw32-make.exe -f Make_ming.mak ARCH=x86-64 MBYTE=yes IME=yes GIME=yes DYNAMIC_IME=yes CSCOPE=yes DEBUG=no LUA="G:/Lua" DYNAMIC_LUA=yes LUA_VER=53 PYTHON="E:/Python27" PYTHON_VER=27 DYNAMIC_PYTHON=yes PYTHON3="E:/Python37" PYTHON3_VER=37 DYNAMIC_PYTHON3=yes FEATURES=HUGE GUI=yes gvim.exe > "%LOGFILE%"

REM --- Build 命令行版本的vim (vim.exe) ---
echo Building vim.exe ...
REM --- 下面的命令将会编译带有Lua5.3、Python2.7和Python3.7版本的vim，64位机器一定要带ARCH=x86-64参数，不然会报错。相应的lua、python文件目录需要修改成上面步骤中安装相应的目录 ---
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

	等编译完成后还需要将G:\Lua下的Lua53.dll文件复制到G:\vim\vim81文件夹下

	等编译完成后检查是否编译成功：双击打开gvim.exe或者vim.exe，在vim里面输入:echo has('lua') 和:echo has('python')，回车，如果都显示1，则表明编译成功，显示0则没有成功