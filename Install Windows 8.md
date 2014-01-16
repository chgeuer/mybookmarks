#Install Windows 8

- Install Windows 8 from USB Stick
  - Format FAT32, 
  - Bootable (with diskpart.exe), 
  - F:\boot\bootsect.exe /NT60 E:\, 
  - robocopy /E /Z F:\ E:\
- Language Pack installation
  - Mount MUI DVD
  - cd /D \langaages\de-de
  - ren lp.cab lp.mlc 
  - start lp.mlc
