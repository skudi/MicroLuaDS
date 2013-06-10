@echo off

echo Micro Lua DS compiler by Risike [Micro Lua]
echo.

echo Compiling Micro Lua DS...
make

del lua-5.1.3\src\*.o 1> nul 2>&1
del lua-5.1.3\src\*.a 1> nul 2>&1
del lua-5.1.3\src\ds\*.o 1> nul 2>&1
del lua-5.1.3\src\ds\*.a 1> nul 2>&1
del /F /S /Q build 1> nul 2>&1
rmdir build 1> nul 2>&1

echo Finished!

@pause