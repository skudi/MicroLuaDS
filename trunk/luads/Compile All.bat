@echo off

echo Micro Lua DS compiler by Risike
echo.

cd lua-5.1.3
echo Compiling Lualib...
make clean 1> out
cd ..
make clean 1> lua-5.1.3\out
cd lua-5.1.3/
make 1> out
echo Installing Lualib...
make install 1> out
cd ..
timeout /t 2 /nobreak > NUL

"Compile DS.bat"
