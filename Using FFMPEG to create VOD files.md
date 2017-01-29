# Using FFMPEG to create VOD files

```Batchfile
SET FFMPEG="c:\program files\ffmpeg\bin\ffmpeg.exe"
SET GOPSIZE=-g 25
SET GOPSIZE=
SET VIDEOBITRATE=-b:v 1500k
SET RESOLUTION=-s "960x540"
SET RESOLUTION=

REM http://www.idude.net/index.php/how-to-watermark-a-video-using-ffmpeg
SET WATERMARK=   -filter_complex "overlay=main_w-overlay_w-10:main_h-overlay_h-10"
SET WATERMARK=   -filter_complex "overlay=(main_w+overlay_w)/2:(main_h+overlay_h)/2"
SET WATERMARK=   -vf "movie=logo2.png [watermark]; [in][watermark] overlay=main_w-overlay_w-10:main_h-overlay_h-10 [out]"

SET CODEC_MP4=   -vcodec libx264   -pix_fmt yuv420p                     %WATERMARK% %GOPSIZE% %VIDEOBITRATE%
SET CODEC_WEBM=  -vcodec libvpx    -acodec libvorbis -ab 160000 -f webm %WATERMARK% %GOPSIZE% %VIDEOBITRATE%
SET CODEC_OGV=   -vcodec libtheora -acodec libvorbis -ab 160000         %WATERMARK% %GOPSIZE% %VIDEOBITRATE%
SET CODEC_POSTER= -ss 00:02 -vframes 1 -r 1              -f image2        %WATERMARK% 

%FFMPEG% -i %1 %CODEC_MP4%    %RESOLUTION% "%~n1.mp4"
%FFMPEG% -i %1 %CODEC_WEBM%   %RESOLUTION% "%~n1.webm"
%FFMPEG% -i %1 %CODEC_OGV%    %RESOLUTION% "%~n1.ogv"
%FFMPEG% -i %1 %CODEC_POSTER% %RESOLUTION% "%~n1.jpg"

REM http://stackoverflow.com/questions/7333232/concatenate-two-mp4-files-using-ffmpeg
REM file '1.mp4'
REM file '2.mp4'
REM %FFMPEG% -f concat -i mylist.txt -c copy output

REM Remux MOV to MP4
ffmpeg -i input.mov -vcodec copy -acodec libvo_aacenc -map_metadata 0 result.mp4

dir *.MOV | foreach { ffmpeg -i $_.Name -vcodec copy -acodec libvo_aacenc $_.Name.Replace("MOV", "mp4") }


REM Remux MKV to MP4
ffmpeg -i a.mkv -vcodec copy -ab 128k -acodec libvo_aacenc -map_metadata 0 a.mp4
ffmpeg -i a.mkv -vcodec copy -acodec copy                  -map_metadata 0 a.mp4
```
# Convert FLV (Flash Video) into real MP4

Files are FLVs, but named MP4. Make them *real* MP4. The ``-map_metadata 0`` ensures that metadata like date etc flows over to the new file.

```Powershell
dir *.mp4 | foreach { Rename-Item $_.Name  $_.Name.Replace("MP4", "flv").Replace("mp4", "flv") }
dir *.flv | foreach { ffmpeg -i $_.Name -vcodec copy -acodec copy         -map_metadata 0 $_.Name.Replace('FLV', 'mp4').Replace('flv', 'mp4') }
dir *.MOV | foreach { ffmpeg -i $_.Name -vcodec copy -acodec libvo_aacenc -map_metadata 0 $_.Name.Replace('MOV', 'mp4').Replace('mov', 'mp4')  }
```

```console
powershell -Command "dir *.MOV | foreach { ffmpeg -i $_.Name -vcodec copy -acodec libvo_aacenc -map_metadata 0 $_.Name.Replace('MOV', 'mp4').Replace('mov', 'mp4') }"
powershell -Command "dir *.AVI | foreach { ffmpeg -i $_.Name -map_metadata 0 $_.Name.Replace('AVI', 'mp4').Replace('avi', 'mp4') }"
```


# Concatenate video files

In order to concatenate MP4 files, each file must be converted into a Transport Stream (.ts), i.e. without a MOOV atom, and then concatenated and re-written into a proper .mp4 file (with MOOV atom): 

```Powershell
dir *.mp4 | foreach { ffmpeg -i $_.Name -c copy -bsf:v h264_mp4toannexb -f mpegts $_.Name.Replace("MP4", "ts").Replace("mp4", "ts") }

ffmpeg -i "concat:intermediate1.ts|intermediate2.ts" -c copy -bsf:a aac_adtstoasc output.mp4
```

Alternatively, you can list all input files in a text file: 

```shell
$ cat m.txt
file 'm1-01 - Introduction - Introduction.ts'
file 'm1-02 - Introduction - Tools.ts'

$ ffmpeg -f concat -i list.txt -c copy -bsf:a aac_adtstoasc output.mp4
```


# Create MP4 from single images

```Powershell
ffmpeg -start_number 3407 -i img_%4d.jpg -c:v libx264 -s "1404x936" out.mp4
```

# Using RTMPDump to fetch an RTMP source

- See also http://stream-recorder.com/forum/tutorial-using-rtmpdump-download-bbc-iplayer-t7368.html
- http://rtmpdump.mplayerhq.hu/ and http://rtmpdump.mplayerhq.hu/download/rtmpdump-2.4-git-010913-windows.zip

```cmd
rtmpdump --protocol 0 --host cp45414.edgefcs.net -a "ondemand?auth=daEa9dhbhaJd4dmc8bicPd1cJdcdzcUcwcd-btFUIl-bWG-CqsEHnBqLEpGnxK&aifp=v001&slist=public/mps_h264_med/public/news/world/1078000/1078809_h264_800k.mp4;public/mps_h264_lo/public/news/world/1078000/1078809_h264_496k.mp4;public/mps_h264_hi/public/news/world/1078000/1078809_h264_1500k.mp4" -y "mp4:public/mps_h264_lo/public/news/world/1078000/1078809_h264_496k.mp4" -o someresolution.flv

ffmpeg -i someresolution.flv  -c:v copy -c:a copy someresolution.mp4

rtmpdump --protocol 0 --host cp45414.edgefcs.net -a "ondemand?auth=daEa9dhbhaJd4dmc8bicPd1cJdcdzcUcwcd-btFUIl-bWG-CqsEHnBqLEpGnxK&aifp=v001&slist=public/mps_h264_hi/public/news/world/1078000/1078809_h264_1500k.mp4" -y "mp4:public/mps_h264_hi/public/news/world/1078000/1078809_h264_1500k.mp4" -o 1078809_h264_1500k.flv

ffmpeg -i 1078809_h264_1500k.flv  -c:v copy -c:a copy 1078809_h264_1500k.mp4
```

- [YouTube Advanced encoding settings](http://support.google.com/youtube/answer/1722171)

```
ffmpeg -i "1.mkv" -vcodec h264 -acodec libvo_aacenc "1.mp4"
ffmpeg -i "1.mkv" -vcodec copy -acodec libvo_aacenc "1.mp4"
```


# Download YouTube and create an animated GIF from sub-part

```batch
youtube-dl.exe https://www.youtube.com/watch?v=bY73vFGhSVk

REM Trim time and crop sub-part and save as mp4
ffmpeg -i "Zootopia Official US Sloth Trailer-bY73vFGhSVk.mp4" -ss 00:01:49 -t 00:00:11.3 -vf "crop=480:320:600:100" -c:v libx264 -c:a aac -strict experimental -b:a 128k "laughing sloth.mp4"

REM generate color palette
ffmpeg -i "laughing sloth.mp4" -y -vf fps=10,scale=320:-1:flags=lanczos,palettegen palette.png

REM Render GIF using palette
ffmpeg -i "laughing sloth.mp4" -i palette.png -filter_complex "fps=10,scale=320:-1:flags=lanczos[x];[x][1:v]paletteuse" output.gif
```


# Capture web cam on my Lenovo

```batch
ffmpeg -list_devices true -f dshow -i dummy

ffmpeg -f dshow -i video="Integrated Camera":audio="Microphone Array (Realtek High Definition Audio)" out.mp4
```

# Concatenate videos

## Convert individually to TS

```bash
ffmpeg -i "m0-01 - A.mp4" -c copy -bsf:v h264_mp4toannexb -f mpegts "m0-01 - A.ts"
ffmpeg -i "m1-01 - B.mp4" -c copy -bsf:v h264_mp4toannexb -f mpegts "m1-01 - B.ts"
```

## `ts.txt`

```powershell

("file '" + (((dir "*.ts" | select -ExpandProperty Name) -replace "'", "\'") -join "'`nfile '") + "'") | Out-File -Encoding ascii -FilePath ts.txt

```

```text
file 'm0-01 - A.ts'
file 'm1-01 - B.ts'
```

## Concatenate

```bash
ffmpeg -f concat -i ts.txt -c copy -bsf:a aac_adtstoasc output.mp4
```



```powershell

dir *.mp4 | foreach { ffmpeg -i $_.Name -c copy -bsf:v h264_mp4toannexb -f mpegts $_.Name.Replace("MP4", "ts").Replace("mp4", "ts") }

("file '" + (((dir "*.ts" | select -ExpandProperty Name) -replace "'", "\'") -join "'`nfile '") + "'") | Out-File -Encoding ascii -FilePath ts.txt

ffmpeg -f concat -i ts.txt -c copy -bsf:a aac_adtstoasc output.mp4

```
