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

REM Remux MKV to MP4
ffmpeg -i a.mkv -vcodec copy -ab 128k -acodec libvo_aacenc a.mp4
ffmpeg -i a.mkv -vcodec copy -acodec copy a.mp4

```
