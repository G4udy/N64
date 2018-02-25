N64 DD Japanese To English Translation
=======================================
<br />
** This translation is now discontinued **<br />
Please go to: https://github.com/LuigiBlood/Translate/tree/master/64DD/Mario%20Artist%20Polygon%20Studio<br />
For a full 100% complete translation by LuigiBlood.<br />
<br />
Translation by krom (Peter Lemon).<br />
<br />
All code compiles out of box with the bass assembler by byuu.<br />
I use a special version of bass by ARM9 which has been updated with N64 MIPS output:<br />
https://github.com/ARM9/bass<br />
I have also included a xdelta 3 file of the translation as a patch.<br />
<br />
Special thanks to Zoinkity, who created a cart version of the game.<br />
Which is playable on real N64 hardware with 64drive =D<br />
Please check out RomHacking & their forum, a great resource for translation work:<br />
http://www.romhacking.net<br />
<br />
Howto Compile:<br />
Disk Version:
You will need the original Japanese disk image in .ndd (Big-Endian) Format, in the root directory of this patch<br />
All the code compiles into a single binary (ROMNAME.ndd) file.<br />
Using bass Run: makedisk.bat<br />
Or you can patch the original Japanese disk image using the xdelta 3 file.<br />
<br />
Cart Version:
You will need the Zoinkity Japanese cart ROM in .n64 (Big-Endian) Format, in the root directory of this patch<br />
All the code compiles into a single binary (ROMNAME.n64) file.<br />
Using bass Run: makecart.bat<br />
Or you can patch the Zoinkity Japanese cart ROM using the xdelta 3 file.<br />
<br />
Howto Run:<br />
I only test with a real N64 using a 64drive Cartridge by Retroactive:<br />
http://64drive.retroactive.be<br />
<br />
You can also use N64 emulators like cen64 & the MESS N64 Driver.
