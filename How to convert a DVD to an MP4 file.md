# How to convert a DVD to an MP4 file

- http://www.howtogeek.com/102886/how-to-decrypt-dvds-with-hardbrake-so-you-can-rip-them/
- http://lifehacker.com/5559007/the-hassle+free-guide-to-ripping-your-blu+ray-collection
- Install [Handbrake 32bit](http://handbrake.fr/rotation.php?file=HandBrake-0.9.9-1_i686-Win_GUI.exe)  
- Install [XBMC 32bit](http://mirrors.xbmc.org/releases/win32/xbmc-12.2.exe)


```Batch
copy "c:\Program Files (x86)\XBMC\system\players\dvdplayer\libdvdcss-2.dll" "c:\Program Files (x86)\Handbrake\libdvdcss.dll"
"c:\Program Files (x86)\Handbrake\Handbrake.exe
```
