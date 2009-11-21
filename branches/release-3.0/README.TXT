Micro Lua DS 3.0
By Risike

Official website : www.microlua.risike.com


HOW TO INSTALL ?
----------------

Put the lua directory at the root of your SD card. You can put your own scripts in /lua/scripts, it's the best way.

Put microlua.nds, microlua.sc.nds or microlua.ds.gba where you want on you SD card.


RELEASE NOTE
------------

3.0:

Corrected bugs:

- Double-click issue
- Jpg loading issue. You can now load .jpg and .jpeg files without problem
- Image loading optimisation. You can load and destroy images, font and maps indefinitely.
- No more "Oops unhandled error"
- Correct the Canvas ATTR_Y2 bug
- Correct the "non-permanent" scaling problem
- Correct the Stylus.newPress problem
- Big speed increase during lua file loading. So, Micro Lua and you scripts are loaded faster

New features:

- Added Wifi support
- Added DateTime support
- Added Rumble support
- Added Motion support
- Sound syntax changed
- You can now play several mods in the same time
- SFX support (you can now play wave files)
- Added a new render() function, no need to use startDrawing() and stopDrawing(), but you can still use them
- Added a MICROLUA_VERSION global variable
- You can now customize the shell in the shell.ini file
- Stylus support in the shell
- No more position limit for direct drawing and printing
- Added a new getStringWidth function which return the width (in pixel) of a string, using a custom font

Removed:

- Keyboard library removed but you can download it on the official website in open source. So you can modify it



2.0 beta:

- Displaying is about 3X FASTER!
- Some syntax changes (see "syntax changes.txt")
- Adding a Canvas system. You can now create a Canvas, adding some objects inside like lines, rectangles, images...etc. Then call Canvas.draw function to draw all items. This method is aboute 30X FASTER than displaying of Micro Lua 1.0!!! On no$gba you can display 1600 images without loss of FPS.
- Adding an INI file management system. You can now read and write ini files.
- Adding ScrollMaps. They are maps we can scroll pixel by pixel. It's faster than normal Maps (faster than 1.0 too) but you can only display them in fullscreen.
- A getTile function for maps
- Some bugs corrections
- Better errors management


1.0.1 beta:

This version correct the bug with Exceptions. Now when an error occured, it will displayed on the lowser screen.


1.0 beta:

First public release
