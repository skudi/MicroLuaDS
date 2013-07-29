@echo off

echo Micro Lua DS compiler
echo By Risike, Reylak, community [lualib]
echo.

echo Compiling Micro Lua DS...
make

del lua\src\*.o 1> nul 2>&1
del lua\src\*.a 1> nul 2>&1
del lua\src\ds\*.o 1> nul 2>&1
del lua\src\ds\*.a 1> nul 2>&1
del /F /S /Q build 1> nul 2>&1
rmdir build 1> nul 2>&1

echo Finished!

@pause
