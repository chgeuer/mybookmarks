# FFMPEG Recipies

### Convert YT videos

```powershell

dir *.webm | foreach { ffmpeg -i $_.Name -ab 192k $_.Name.Replace("WEBM", "mp3").Replace("webm", "mp3") }

dir *.mkv | foreach { ffmpeg -i $_.Name -ab 192k $_.Name.Replace("mkv", "mp3") }

dir *.mkv | foreach { ffmpeg -i $_.Name -vcodec copy -acodec copy -map_metadata 0 $_.Name.Replace("mkv", "mp4") }

dir *.mkv | foreach { ffmpeg -i $_.Name -vcodec copy -ab 192k -map_metadata 0 $_.Name.Replace("mkv", "mp4") }

```

### Download HLS

```
ffmpeg -i https://...akamaihd.net/.../name/a.mp4/index.m3u8 -c copy -bsf:a aac_adtstoasc "foo.mp4"
```
