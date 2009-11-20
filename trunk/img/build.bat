@echo off
REM based on davr http://blog.davr.org/ linux code and shell script
REM by Troy(GPF) http://gpf.dcemu.co.uk

echo Builds a FAT disk image from a given directory.
if "%1" == "" goto ERROR
if "%2" == "" goto ERROR
set size=8192
for %%i in (%2\*) do set /A size = "size + (((%%~zi + 4095) >> 12) << 12)"
rem set /A size="%info%+1024"
echo %size%

if /I %size% LSS 10000  (  set /A size="10000" )

echo Creating image
mkdosfs.exe %1 %size%
bfi.exe -f=%1 %2
rem 'bless' the image so it is recognized by FCSR driver, and sets up SRAM overlay

echo Blessing image
bless.exe %1
echo "FAT12 image built as %1 from /%2"
goto :end

:ERROR
echo usage: build.bat name.img dirname
goto :end

:tobig
echo directory size to large , remove some files and try again
goto :end


:end


exit
