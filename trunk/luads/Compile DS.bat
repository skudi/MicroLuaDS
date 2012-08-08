@echo off

echo Micro Lua DS compiler by Risike
echo.

echo Compiling Micro Lua DS...
make

del lua-5.1.3\src\*.o 2> lua-5.1.3\out2 1> lua-5.1.3\out
del lua-5.1.3\src\*.a 2> lua-5.1.3\out2 1> lua-5.1.3\out
del lua-5.1.3\src\ds\*.o 2> lua-5.1.3\out2 1> lua-5.1.3\out
del lua-5.1.3\src\ds\*.a 2> lua-5.1.3\out2 1> lua-5.1.3\out
del /F /S /Q build 1> lua-5.1.3\out 1> lua-5.1.3\out
rmdir build 1> lua-5.1.3\out 1> lua-5.1.3\out

echo Finished!

@pause