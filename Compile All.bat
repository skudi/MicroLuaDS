@echo off

echo Micro Lua DS compiler
echo By Risike, Reylak, community [lualib]
echo.

echo Compiling Lualib...
make clean 1> nul 2>&1
cd lua
make clean 1> nul 2>&1 && make 1> out
echo.

echo Installing Lualib...
make install
cd ..

echo.
"Compile DS.bat"
