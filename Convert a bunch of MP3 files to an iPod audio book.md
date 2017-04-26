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
