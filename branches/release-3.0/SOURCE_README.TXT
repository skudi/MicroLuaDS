How to compile Micro Lua DS ?

1) Install devkitpro.
You need Devkitarm r24 !!!!!!!!!!!!! Not another one !!!!
 Download it and replace the latest devkitarm.

2) Choose if you want to compile for NDS or NO$GBA :
Change the first line of Fat/libs.lua :
	COMPILE_FOR_DS = 1 -- 0: no, 1: yes
And change the first line of source/main.c :
	#define COMPILE_FOR_DS 1	// 1: yes, 0: no$gba

3) Run Compile All.bat (il you have errors, juste run it angain).
There are some warnings due to new devkitpro register names... Forget it.

Compile All.bat will compile the lualib and Micro Lua DS.
You MUST run at least on time. Then if you don't touch to the lualib code but
just the source/main.c, you can only run Compile DS.bat.

More detailed info here: http://code.google.com/p/microlua/wiki/HowToCompile
or in the off line documentation.

Any Question ? Go to the Micro Lua DS official forum : http://microlua.xooit.fr
