@echo off

echo Micro Lua DS compiler by Risike [lualib]
echo.

cd lua-5.1.3
echo Compiling Lualib...
make clean 1> nul 2>&1
cd ..
make clean 1> nul 2>&1
cd lua-5.1.3/
make 1> out
echo.
echo Installing Lualib...
make install
cd ..
timeout /t 2 /nobreak > NUL

echo.
"Compile DS.bat"
