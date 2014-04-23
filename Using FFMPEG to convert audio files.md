
# Interesting FFMPEG Articles

- http://sonnati.wordpress.com/2011/07/11/ffmpeg-the-swiss-army-knife-of-internet-streaming-part-i/
- http://sonnati.wordpress.com/2011/08/08/ffmpeg-%e2%80%93-the-swiss-army-knife-of-internet-streaming-%e2%80%93-part-ii/
- http://sonnati.wordpress.com/2011/08/19/ffmpeg-%e2%80%93-the-swiss-army-knife-of-internet-streaming-%e2%80%93-part-iii/
- http://sonnati.wordpress.com/2011/08/30/ffmpeg-%e2%80%93-the-swiss-army-knife-of-internet-streaming-%e2%80%93-part-iv/
- http://sonnati.wordpress.com/2012/07/02/ffmpeg-the-swiss-army-knife-of-internet-streaming-part-v/
- http://sonnati.wordpress.com/2012/10/19/ffmpeg-the-swiss-army-knife-of-internet-streaming-part-vi/
- [ffmbc - FFMedia Broadcast](https://code.google.com/p/ffmbc/)




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

# Convert a bunch of MP3 files to an iPod audio book

```Powershell
# Convert a bunch of MP3 files to an iPod audio book

$folder = "C:\Users\Public\Music\Star Wars Episode 1 - Die dunkle Bedrohung"

Function concatenate($lines) {
    $sb = New-Object -TypeName "System.Text.StringBuilder";
    [void]$sb.Append("""");
    [void]$sb.Append("concat:");
    for ($i=0; $i -le $lines.Length; $i++) {
        [void]$sb.Append($lines[$i].Name);
        if ($i -le ($lines.Length - 2)) {
            [void]$sb.Append("|");
        }
    }
    [void]$sb.Append("""");
    return $sb.ToString();
}
Set-Location $folder
$filename = (Get-Item $folder).Name
$inputfiles = Get-ChildItem -Filter *.mp3 | Sort-Object -Property Name
$concatenation = concatenate($inputfiles)

# ffmpeg -i "concat:01.mp3|02.mp3" -c:a libvo_aacenc -vn 1.m4a
ffmpeg -i $concatenation -c:a libvo_aacenc -vn "$filename.m4a"
# Rename-Item -Path "$filename.m4a" -NewName "$filename.m4b"

# compare two videos @see http://ianfeather.co.uk/compare-two-webpagetest-videos-using-ffmpeg/
ffmpeg -i before.mp4 -i after.mp4 -filter_complex "[0:v:0]pad=iw*2:ih[bg]; [bg][1:v:0]overlay=w" output.mp4

```
