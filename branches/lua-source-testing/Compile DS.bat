@echo off

set LUA_SRC_DIR=lua

echo Micro Lua DS compiler by Risike
echo.

echo Creating fcsr image...
cd img  
start /B makeimg.cmd
sleep 0.5
cd ..  
del luads.img  2> %LUA_SRC_DIR%\out2 1> %LUA_SRC_DIR%\out
cp img\luads.img . 2> %LUA_SRC_DIR%\out2 1> %LUA_SRC_DIR%\out
sleep 0.5

echo Compiling Micro Lua DS...
make

del %LUA_SRC_DIR%\src\*.o 2> %LUA_SRC_DIR%\out2 1> %LUA_SRC_DIR%\out
del %LUA_SRC_DIR%\src\*.a 2> %LUA_SRC_DIR%\out2 1> %LUA_SRC_DIR%\out
del %LUA_SRC_DIR%\src\ds\*.o 2> %LUA_SRC_DIR%\out2 1> %LUA_SRC_DIR%\out
del %LUA_SRC_DIR%\src\ds\*.a 2> %LUA_SRC_DIR%\out2 1> %LUA_SRC_DIR%\out
del /F /S /Q build 1> %LUA_SRC_DIR%\out 1> %LUA_SRC_DIR%\out
rmdir build 1> %LUA_SRC_DIR%\out 1> %LUA_SRC_DIR%\out
del %LUA_SRC_DIR%\out
del %LUA_SRC_DIR%\out2

del luads_tst.nds 2> %LUA_SRC_DIR%\out2 1> %LUA_SRC_DIR%\out
del luads.img  2> %LUA_SRC_DIR%\out2 1> %LUA_SRC_DIR%\out

echo Finished !

pause