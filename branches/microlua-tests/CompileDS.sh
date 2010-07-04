#!/bin/sh

echo Micro Lua DS compiler by Risike
echo .

echo Creating fcsr image...
cd img
screen $(pwd)/makeimg.sh
sleep 0.5
cd ../
if [ -e dualua.img ]
then
	rm luads.img  2> lua-5.1.3/out2 1> lua-5.1.3/out
fi
cp img/luads.img . 2> lua-5.1.3/out2 1> lua-5.1.3/out
sleep 0.5

echo Compiling Micro Lua DS...
make

rm lua-5.1.3/src/*.o 2> lua-5.1.3/out2 1> lua-5.1.3/out
rm lua-5.1.3/src/*.a 2> lua-5.1.3/out2 1> lua-5.1.3/out
rm lua-5.1.3/src/ds/*.o 2> lua-5.1.3/out2 1> lua-5.1.3/out
rm lua-5.1.3/src/ds/*.a 2> lua-5.1.3/out2 1> lua-5.1.3/out
rm -r build 1> lua-5.1.3/out 1> lua-5.1.3/out
rm lua-5.1.3/out
rm lua-5.1.3/out2

rm dualua_tst.nds 2> lua-5.1.3/out2 1> lua-5.1.3/out
rm dualua.img  2> lua-5.1.3/out2 1> lua-5.1.3/out

echo Finished !

