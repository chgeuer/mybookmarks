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
ffmpeg -i input.mov -vcodec copy -acodec libvo_aacenc result.mp4

dir *.MOV | foreach { ffmpeg -i $_.Name -vcodec copy -acodec libvo_aacenc $_.Name.Replace("MOV", "mp4") }


REM Remux MKV to MP4
ffmpeg -i a.mkv -vcodec copy -ab 128k -acodec libvo_aacenc a.mp4
ffmpeg -i a.mkv -vcodec copy -acodec copy a.mp4

```

# Convert FLV (Flash Video) into real MP4

Files are FLVs, but named MP4. Make them *real* MP4

```Powershell
dir *.mp4 | foreach { Rename-Item $_.Name  $_.Name.Replace("mp4", "flv") }
dir *.flv | foreach { ffmpeg -i $_.Name -vcodec copy -acodec copy $_.Name.Replace("flv", "mp4") }
```

# Concatenate video files

In order to concatenate MP4 files, each file must be converted into a Transport Stream (.ts), i.e. without a MOOV atom, and then concatenated and re-written into a proper .mp4 file (with MOOV atom): 

```Powershell
dir *.mp4 | foreach { ffmpeg -i $_.Name -c copy -bsf:v h264_mp4toannexb -f mpegts $_.Name.Replace("mp4", "ts") }

ffmpeg -i "concat:intermediate1.ts|intermediate2.ts" -c copy -bsf:a aac_adtstoasc output.mp4
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
