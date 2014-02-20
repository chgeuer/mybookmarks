# Using FFMPEG to convert audio files

```Powershell
ffmpeg -i infile.flac outfile.wav

REM http://etree.org/shnutils/shntool/
shntool.exe split -f infile.cue -t %n-%t -m /- outfile.wav

dir *.wav | foreach { ffmpeg -i $_.Name -ab 320k $_.Name.Replace("wav", "mp3") }

REM Convert FLAC to MP3 VBR
dir *.flac | foreach { ffmpeg -i $_.Name -qscale:a 1 $_.Name.Replace("flac", "mp3") }

REM Convert FLAC to MP3 320k
dir *.flac | foreach { ffmpeg -i $_.Name -ab 320k $_.Name.Replace("flac", "mp3") }


REM Create M4B from MP3
ffmpeg -i "concat:01.mp3|02.mp3" -c:a libvo_aacenc -vn out.m4a
ren out.m4a out.m4b
```



Files are FLVs, but named MP4. Make them *real* MP4

```Powershell
dir *.mp4 | foreach { Rename-Item $_.Name  $_.Name.Replace("mp4", "flv") }
dir *.flv | foreach { ffmpeg -i $_.Name -vcodec copy -acodec copy $_.Name.Replace("flv", "mp4") }
```
