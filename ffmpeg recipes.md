# ffmpeg recipes

## Originals from here: 

- http://sonnati.wordpress.com/2011/07/11/ffmpeg-the-swiss-army-knife-of-internet-streaming-part-i/
- http://sonnati.wordpress.com/2011/08/08/ffmpeg-%e2%80%93-the-swiss-army-knife-of-internet-streaming-%e2%80%93-part-ii/
- http://sonnati.wordpress.com/2011/08/19/ffmpeg-%e2%80%93-the-swiss-army-knife-of-internet-streaming-%e2%80%93-part-iii/
- http://sonnati.wordpress.com/2011/08/30/ffmpeg-%e2%80%93-the-swiss-army-knife-of-internet-streaming-%e2%80%93-part-iv/
- http://sonnati.wordpress.com/2012/07/02/ffmpeg-the-swiss-army-knife-of-internet-streaming-part-v/
- http://sonnati.wordpress.com/2012/10/19/ffmpeg-the-swiss-army-knife-of-internet-streaming-part-vi/


# First part – Intro

This is the start post of a small series dedicated to FFmpeg. I have already talked about it 6 years ago when this tool was still young (Why I love FFmpeg: post1 and post2) but in these 6 years it has evolved widely and now it is a really useful “swiss army knife” for Internet streaming. I could define FFmpeg also as one of the pilllars of Internet Video. Sites like YouTube, Vimeo, Google video and the entire trend of UGC would not exist without FFmpeg. It is an exceptionally flexible tool that can be very useful for who works in the streaming business and most of all it is open source, free and well supported.

## A brief history of FFmpeg

From wikipedia:
“FFmpeg is a free software / open source project that produces libraries and programs for handling multimedia data. The most notable parts of FFmpeg are libavcodec, an audio/video codec library used by several other projects, libavformat, an audio/video container mux and demux library, and the ffmpeg command line program for transcoding multimedia files. FFmpeg is published under the GNU Lesser General Public License 2.1+ or GNU General Public License 2+ (depending on which options are enabled). The project was started by Fabrice Bellard, and has been maintained by Michael Niedermayer since 2004.”

So FFmpeg is the command line program that using libavcodec, libavformat and several other open source programs (notably x264 for H.264 encoding) offers exceptional transcoding capabilities especially for server side batch transcoding, but also for live encoding and audio/video files manipulation (muxing, demuxing, slicing, splitting and so on).

## Me and FFmpeg

I started to study video encoding optimization during University and in the last decade I have used several open source and commercial encoders and designed my own original approaches and optimizations to encoding (take a look at best articles page for some experiments). But video encoding  and streaming became a business for me only after the release of FMS and Flash Player 6 in the late 2002. In the next years I developed several real time communication programs for my clients and a couple products. One of these was the “BlackBox” (2005), an HW/SW appliance that acquired multiple video sources using a Flash front-end and a FMS back-end. The system not only acquired video but provided also video editing features.

And here started my FFmpeg discovery. I needed a tool, possibly free, to manipulate FLV (cut, join, resize, re-encode, etc…) to provide the primitive operations of video editing. Being a .net developer I created my own tools (especially for splitting and joining) but then I found FFmpeg to be the best solution to do the most complex parts of the work. So my confidence with FFmpeg dates back to 2005. Around the same year Youtube started to use it as a free and fast way to encode (almost) any video format in input to a common output format (Sorenson’s Spark) for playback in Flash… you know the rest of the story.

Services like Youtube could not afford massive video transcoding using commercial solutions, so a tool like FFmpeg has been of fundamental importance for the sostenibility of their business model. This is why I defined FFmpeg as one of the pillars of Internet Video.

## What is it possible to do with FFmpeg ?

The most obvious functionality is the decoding and encoding of audio and video files (transcoding). FFmpeg accepts an exceptional number of formats in input and is capable to decode, process (resize, change fps, filter, deinterlace, and so on) and finally encode to several output formats. But it can do a lot of other useful tasks like extract the elementary AV streams from a container, mux elementary streams in a new container, cut portions from a video, extract track informations.

These are features that FFmpeg has from many years while only more recently has been added the support for RTMP protocol (librtmp)

I think that, for an Internet Streaming professional, this has become one of the most important feature of FFmpeg. Before, if you wanted to acquire streams or push streams to a server in live mode you needed to use the RTP/RTSP protocol, but it is too complex and the implementation not really stable. On the other hand, RTMP is a simple yet powerful protocol and most important of all, it is supported by FMS and Wowza which are the most used streaming server in the last 5 years.

For example with librtmp it is possible to:

1. Connect to FMS, subscribe a live or vod stream and record it to file system.
2. Connect to FMS, subscribe a stream, transcode and publish a new version to a different or the same FMS.
3. Publish a local video file to FMS to simulate live streaming (with or without transcoding).
4. Acquire a live feed on the local PC, transcode and publish to FMS.

# Parameters and recipes 

After the short introduction of the previous article, now it’s time to see FFmpeg in action. This post is dedicated to the most important parameters and ends with an example of transcoding to H.264. FFmpeg supports hundreds of AV formats and codecs as input and output (for a complete list type ffmpeg -formats and ffmpeg -codecs) but you know that nowadays the most important output format is without doubt H.264.

H.264 is supported by Flash (99% of computers + mobile), iOS, Android, BlackBerry, low-end mobile devices, STBs and Connected TVs. So why target different formats ? A streaming professional has primarily to master H.264. Other formats are marginal, even Google’s VP8 which is still in a too early phase of adoption.

FFmpeg is vast subject, so I’ll focus on what I think to be the most important options and a useful selection of command lines. But first of all, how to find a build of FFmpeg to start managing your video?

The shortest path if you don’t want to built from source code is to visit Zeranoe’s FFmpeg builds. Remember that there are several libraries that can be included or excluded in the build and so if you need something special or a fine control onthe capabilities of your build, the longest path is the best.

KEY PARAMETERS

This is the base structure of an FFmpeg invocation:

ffmpeg -i input_file [...parameter list...] output_file

Input_file and output_file can be defined not only as file system objects but a number of protocols are supported: file, http, pipe, rtp/rtsp, raw udp, rtmp. I’ll focus on the possiblity to use RTMP as input and/or output in the fourth part of this series, while in the following examples I’ll use only the local file option.

FFmpeg supports litterally hundreds of parameters and options. Very often, FFmpeg infers the parameters from the context, for example the input or output format from the file extention and it also applies default values to unspecified parameters. Sometimes it is instead necessary to specify some important parameters to avoid errors or to optimize the encoding.

Let’s start with a selection of the most important, not codec related, parameters:
	-formats   print the list of supported file formats
	-codecs    print the list of supported codecs (E=encode,D=decode)
	-i         set the input file. Multiple -i switchs can be used
	-f         set video format (for the input if before of -i, for output otherwise)
	-an        ignore audio
	-vn        ignore video
	-ar        set audio rate (in Hz)
	-ac        set the number of channels
	-ab        set audio bitrate
	-acodec    choose audio codec or use “copy” to bypass audio encoding
	-vcodec    choose video codec or use “copy” to bypass video encoding
	-r         video fps. You can also use fractional values like 30000/1001 instead of 29.97
	-s         frame size (w x h, ie: 320x240)
	-aspect    set the aspect ratio i.e: 4:3 or 16:9
	-sameq     ffmpeg tries to keep the visual quality of the input
	-t N       encode only N seconds of video (you can use also the hh:mm:ss.ddd format)
	-croptop, -cropleft, -cropright, -cropbottom   crop input video frame on each side
	-y         automatic overwrite of the output file
	-ss        select the starting time in the source file
	-vol       change the volume of the audio
	-g         Gop size (distance between keyframes)
	-b         Video bitrate
	-bt        Video bitrate tolerance
	-metadata  add a key=value metadata

## SYNTAX UPDATE (*)

The syntax of some commands have changed. Commands like -b (is the bitrate related to audio or video?) have now a different syntax:

Use:

	-b:a instead of -ab to set audio bitrate
	-b:v instead of -b to set video bitrate
	-codec:a or -c:a instead of -acodec
	-codec:v or -c:v instead of -vcodec

Most of these parameters allow also a third optional number to specify the index of the audio or video channel to use.

Es: -b:a:1 to specify the bitrate of the second audio stream (the index is 0 based).

Read official documentation for more info: http://ffmpeg.org/ffmpeg.html

## COMMAND LINES EXAMPLES

And now let’s combine these parameters to manipulate AV files:

### 1. Getting info from a video file

```cmd
ffmpeg -i video.mpg
```

Useful to retrieve info from a media file like audio/video codecs, fps, frame size and other params. You can parse the output of the command line in a script redirecting the stderr channel to a file with a command like this:

```cmd
ffmpeg –i inputfile 2>info.txt
```

### 2. Encode a video to FLV

ffmpeg –i input.avi –r 15 –s 320×240 –an video.flv

By default FFmpeg encodes flv files in the old Sorenson’s Spark format (H.263). This can be useful today only for compatibility with older systems or if you wanto to encode for a Wii (which supports only Flash Player 7).
 Before the introduction of H.264 in Flash Player I was used to re-encode the FLVs recorded by FMS with a command like this:

```cmd
ffmpeg –i input.flv –acodec copy –sameq output.flv
 (ffmpeg –i input.flv –codec:a copy –sameq output.flv)
```

This produced a file 40-50% smaller with the same quality of the input, preserving at the same time the Nellymoser ASAO audio codec which was not supported by FFmpeg in such days and therefore not encodable in something else.

Today you can easily re-encode to H.264 and also transcode ASAO or Speex to something else.

VP6 codec (Flash Player 8+) is officially supported only in decoding.

### 3. Encode from a sequence of pictures

```cmd
ffmpeg -f image2 -i image%d.jpg –r 25 video.flv
```

Build a video from a sequence of frame with a name like image1.jpg,image2.jpg,..,imageN.jpg
 Is it possible to use different naming conventions like image%3d.jpeg where FFmpeg search for file with names like image 001.jpeg, image002.jpg, etc…The output is an FLV file at 25Fps.

### 4. Decode a video into a sequence of frames

ffmpeg -i video.mp4 –r 25 image%d.jpg

Decodes the video in a sequence of images (25 images per second) with names like image1, image2, image 3, … , imageN.jpg. It’s possible to change the naming convention.

```cmd
ffmpeg –i video.mp4 –r 0.1 image%3d.jpg
```

Decodes a picture every 10 seconds (1/0.1=10). Useful to create a thumbnail gallery for your video. In this case the putput files have names like image001, image002, etc.

```cmd
ffmpeg –i video.mp4 –r 0.1 –t 20 image%3d.jpg
```

Extracts 2-3 images from the first 20 seconds of the source.

### 5. Extract an image from a video

```cmd
ffmpeg -i video.avi -vframes 1 -ss 00:01:00 -f image2 image-%3d.jpg
(ffmpeg -i video.avi -frames:v 1 -ss 00:01:00 -f image2 image-%3d.jpg)
```


This is a more accurate command for image extraction. It extracts only 1 single frame (-vframes 1) starting 1min from the start of the video. The thumbnail will have the name image-001.jpg.

```cmd
ffmpeg -i video.avi -r 0.5 -vframes 3 -ss 00:00:05 -f image2 image-%3d.jpg
(ffmpeg -i video.avi -r 0.5 -frames :v 3 -ss 00:00:05 -f image2 image-%3d.jpg)
```

In this case FFmpeg will extract 3 frames, each every 1/0.5=2seconds, starting from time 5s. Useful for video CMS where you want to offer a selection of thumbnails and a backend user choose the best one.

### 6. Extract only audio track without re-encoding

```cmd
ffmpeg -i video.flv -vn -c:a copy audio.mp3
```

Here I assume that the audio track is an mp3. Use audio.mp4 if it is AAC or audio.flv if it is ASAO or Speex. Similarly you can extract the video track without re-encoding.

### 7. Extract audio track with re-encoding

```cmd
ffmpeg -i video.flv -vn -ar 44100 -ac 2 -ab 128k -f mp3 audio.mp3
```

This command extract audio and transcode to MP3. Useful when the video.flv is saved by FMS and has an audio track encoded with ASAO or Speex.

ffmpeg –i video.flv –vn –c:a libaac –ar 44100 –ac 2 –ab 64k audio.mp4

The same as above but encoded to AAC.

### 8. Mux audio + video

```cmd
ffmpeg -i audio.mp4 -i video.mp4 output.mp4
```

Depending by the content of the input file you may need to use the map setting to choose and combine the audio video tracks correctly. Here I suppose to have an audio only and video only input files.

### 9. Change container

```cmd
ffmpeg –i input.mp4 –c:a copy –c:v copy output.flv
```

I use this to put h.264 in FLV container, sometimes it is useful. This kind of syntax will come back when we will talk about FFmpeg and RTMP.

### 10. Grab from a webcam

On Linux it is easy to use an audio or video grabbing device as input to FFmpeg:

```cmd
ffmpeg -f oss -i /dev/dsp -f video4linux2 -i /dev/video0 out.flv
```

On windows it is possible to use vfwcap (only video) or direct show (audio and video):

```cmd
ffmpeg -r 15 -f vfwcap -s 320×240 -i 0 -r 15 -f mp4 webcam.mp4
```

```cmd
ffmpeg -r 15 -f dshow -s 320×240 -i video=”video source name”:audio=”audio source name” webcam.flv
```

Notice here that the parameters –r –f –s are setted before –i.

### 11. Extract a slice without re-encoding

```cmd
ffmpeg -i input -ss 00:01:00 -t 00:01:00 -c:a copy -c:v copy output.mp4
```

Extract 1min of video starting from time 00:01:00. Be aware that putting the -ss and -t parameters before or after -i may have different effects.

### 12. Make a video file from a single frame

ffmpeg -loop_input -frames:v 1 -i frame.jpg -t 10s -r 25 output.mp4

Generate a video with 25Fps and length 10s from a single frame. Playing with -vframes it is possible to loop a sequence of frames (not video). Note: -loop_input is deprecated in favor of -loop (filter option).

### 13. Add metadata

```cmd
ffmpeg -i input.flv -c:v copy -c:a copy -metadata title=”MyVideo” output.flv
```

Useful to change or add metadata like resolution, bitarate or other info

### 14. Encode to H.264

Let’s conclude this second part of the series with an example of encoding to H.264 + AAC. In the example above I have used, for simplicity sake, FLV or MP4 output. But to encode to H.264 you have to explicitly set the output codec and some required parameters.

```cmd
ffmpeg -y -i input.mov -r 25 -b 1000k -c:v libx264 -pass 1 -vpre fastfirstpass -an output.mp4
ffmpeg -y -i input.mov -r 25 -b 1000k -c:v libx264 -pass 2 -vpre hq -acodec libfaac -ac 2 -ar 44100 -ab 128k output.mp4
```

This first example tells FFmpeg to use the libx264 to produce a H.264 output. We are using a two pass encoding (-pass 1 generate only a stat file that will be used by a second pass). The -vpre option tells FFmpeg to use the preset file “fastfirstpass” that its found in the preset folder of the FFmpeg installation directory. The second line performs the second pass using a more accurate preset (-vpre hq) and adds the audio encoding.

FFmpeg use a dedicated remapping of the most important parameters of libx264. x264 has an high number of parameters and if you know what you are doing you can also set each of them individually instead of using a predefined preset. This is an example of two pass encoding without preset:

```cmd
ffmpeg -y -i input -r 25 -b 1000k -c:v libx264 -pass 1 -flags +loop -me_method dia -g 250 -qcomp 0.6 -qmin 10 -qmax 51 -qdiff 4 -bf 3 -b_strategy 1 -i_qfactor 0.71 -cmp +chroma -subq 1 -me_range 16 -coder 1 -sc_threshold 40 -flags2 -bpyramid-wpred-mixed_refs-dct8x8+fastpskip -keyint_min 25 -refs 3 -trellis 0 -directpred 1 -partitions -parti8x8-parti4x4-partp8x8-partp4x4-partb8x8 -an output.mp4

ffmpeg -y -i input -r 25 -b 1000k -c:v libx264 -pass 2 -flags +loop -me_method umh -g 250 -qcomp 0.6 -qmin 10 -qmax 51 -qdiff 4 -bf 3 -b_strategy 1 -i_qfactor 0.71 -cmp +chroma -subq 8 -me_range 16 -coder 1 -sc_threshold 40 -flags2 +bpyramid+wpred+mixed_refs+dct8x8+fastpskip -keyint_min 25 -refs 3 -trellis 1 -directpred 3 -partitions +parti8x8+parti4x4+partp8x8+partb8x8 -acodec libfaac -ac 2 -ar 44100 -ab 128k output.mp4
```

# Encoding in H.264 / Third part

In this third part we will look more closely at the parameters you need to know to encode to H.264.

FFmpeg uses x264 library to encode to H.264. x264 offers a very wide set of parameters and therefore an accurate control over compression. However you have to know that FFmpeg applies a parameter name re-mapping and doesn’t offer the whole set of x264 options.

UPDATE: FFmpeg allows to specify directly the parameters to the underling x264 lib using the option -x264opt. -x264opt accept parameters as key=value pairs separated by “:”. ES: -x264opt bitrate=1000:profile=baseline:level=4.1…etc.

Explain the meaning of all the parameters is a long task and it is not the aim of this article. So I’ll describe only the most important and provide some useful samples. Therefore, if you want to go deeper in the parameterization of FFmpeg, I can suggest you to read this article to know the meaning of each x264 parameters and the mapping between FFmpeg and x264. To know more about the technical principles of H.264 encoding, I suggest also to take a look at the first part of my presentions at MAX2008, MAX2009 and MAX2010.

## ENCODING IN H.264 WITH FFMPEG

Let’s start analyzing a sample command line to encode in H.264 :

```cmd
ffmpeg -i INPUT -r 25 -b 1000k –s 640×360 -c:v libx264 -flags +loop -me_method hex -g 250 -qcomp 0.6 -qmin 10 -qmax 51 -qdiff 4 -bf 3 -b_strategy 1 -i_qfactor 0.71 -cmp +chroma -subq 8 -me_range 16 -coder 1 -sc_threshold 40 -flags2 +bpyramid+wpred+mixed_refs+dct8x8+fastpskip -keyint_min 25 -refs 3 -trellis 1 –level 30 -directpred 1 -partitions -parti8x8-parti4x4-partp8x8-partp4x4-partb8x8 -threads 0 -acodec libfaac -ar 44100 -ab 96k -y OUTPUT.mp4
```

(UPDATE: libfaac is now an external library and maybe you can have problem encoding in AAC – Read part V of the series to know more about this topic.)

This command line encodes the INPUT file using a framerate of 25 Fps (-r), a target bitrate of 1000Kbit/s (-b), a gop max-size of 250 frames (-g), 3 b-frames (-bf) and resizing the input to 640×360 (-s). The level is set to 3.0 (-level), the entropy coder to CABAC (-coder 1) and the number of reference frames to 3 (-refs). The profile is determined by the presence of b-frames, dct8x8 and Cabac, so it is an high-profile. Notice the syntax to enable/disable options in the multi options parameters like -partitions, -flags2 and -cmp. The string “-flags2 +bpyramid+wpred+mixed_refs+dct8x8″ means that you are enabling b-pyramid, weighted prediction, mixed references frames and the use of the 8×8 dct. So for example, if you want to disable dct8x8 to generate an output compliant with the main-profile, you can do that changing the previous string to “-flags2 +bpyramid+wpred+mixed_refs-dct8x8″ (notice the “-” character in front of dct8x8 instead of “+”). Disabling dct8x8 you obtain a main profile, disabling also b-frames and CABAC (setting “-bf 0” and  “-codec 0“) you obtain a baseline-profile.

Profiles and Levels are very important for device compatibility so it is important to know how to produce a specific profile and level pair. You find a short primer to profiles and levels here and generic raccomandations for multi device encoding here.

## MAIN PARAMETERS


Here you find a short explanation of the most significative parameters. 

-me_method

Sets the accuracy of the search method in motion estimation. Allowed values: dia (fastest), hex, umh, full (slowest). Dia is usually used for first pass encoding only and full is too slow and not significantly better than umh. For single pass encoding or the second pass in multi-pass encoding use umh or hex depending by encoding speed requirements or constraints.

-subq

Sets the accuracy of motion vectors. Accepts values in the range 1-10. Use lower values like 1-3 for first pass and higher values like 7-10 for the second pass. Again, the effective value depends by a quality/speed tradeoff.

-g, -keyint_min, -sc_threshold

x264 uses by default a dynamic gop size. -g selects the max gop size, -keyint_min the min size. –sc_threshold is the Scene Change sensitivity (0-100). At every scene change a new i-frame (intra compressed frame) is inserted. Depending by -g and -keyint_min an I-frame (IDR frame alias keyframe) is inserted instead. The gop can be long (i.e. -g 300) for compression efficiency sake, or short (i.e. 25/50) for accessibility sake. This depends by what you need to achieve and by the delivery technique used (when using RTMP streaming you can seek to every frame, with progressive downloading only to IDRs). Sometimes you may need to have a consistent, contant gop size across multiple bitrates (i.e. for Http Dynamic Streaming or HLS). To do that set min and max gop size equal and disable completely scene change (i.e. -g 100 -keyint_min 100 -sc-threashold 0).

-bf, b-strategy

-bf sets the max number of consecutive b-frames (H.264 supports up to 16 b-frames). Remember that b-frames are not allowed in baseline profile. B-strategy defines the technique used for b-frames placement.

Use 0 to disable dynamic placement.
 Use 1 to enable a fast-choice technique for dynamic placement. Fast but less accurate.
 Use 2 to enable a slow-and-accurate mode. Can be really slow if used with an high number of b-frames.

-refs

sets the number of reference frames (H.264 supports up to 16 reference frames). Influences the encoding time. Using more than  4-5 refs gives commonly very little or null gain.

 -partitions

H.264 supports several partitions modes for MBs estimation and compensation. P-macroblocks can be subdivided into 16×8, 8×16, 8×8, 4×8, 8×4, and 4×4 partitions. B-macroblocks can be divided into 16×8, 8×16, and 8×8 partitions. I-macroblocks can be divided into 4×4 or 8×8 partitions. Analyzing more partition options improves quality at the cost of speed. The default in FFmpeg is to analyze all partitions except p4x4 (p8x8, i8x8, i4x4, b8x8). Note that i8x8 requires 8x8dct, and is the only partition High Profile-specific. p4x4 is rarely useful (i.e. for small frame size).

-b, -pass, -crf, -maxrate, -bufsize

-b sets the desired bitrate that will be achieved using a single pass or multi-pass process using the -pass parameter. -crf define a desired average quality instead of a target bitrate.
 These are all options retalted to bitrate allocation and rate control. Rate Control is a key area of video encoding and deserves a wider description.


### RATE CONTROL OPTIONS

Particular attention must be paid to the Rate Control mode used. x264 supports different rate control techniques: Average Bit Rate (ABR), Costant Bit Rate (CBR), Variable Bit Rate (VBR at constant quality or constant quantization). Furthermore it is possible to use 1, 2 or more passes.

### MultiPass encoding


FFmpeg supports multi pass encoding. The most common is the 2 pass encoding. In the first pass the encoder collects informations about the video’s complexity and create a stat file. In the 2nd pass the stat file is used for final encoding and better bit allocation. This is the generic syntax:

ffmpeg -i input -pass 1 [parameters] output.mp4
ffmpeg -i input -pass 2 [parameters] output.mp4

-pass 1 tells to FFmpeg to analize video and write a stat file. -pass 2 tells to read the stat file and encode accordingly. Exist also a -pass 3 option that read and update the stat. So if you want to do a 3-pass encoding the correct sequence is:

ffmpeg -i input -pass 1 [parameters] output.mp4
ffmpeg -i input -pass 3 [parameters] output.mp4
 ffmpeg -i input -pass 2 [parameters] output.mp4

3-pass encoding is rarely useful.

ABR

Average Bitrate is the default rate control mode. Simply set the desired target average bitrate using -b. Remember that the bitrate can fluctuate freely locally and only the average value over the whole video duration is controlled. ABR can be performed with 1 or 2 pass but I suggest to always use a 2-pass for better data allocation.

CBR

Using the VBV model (Video Bitrate Verifier) it’s possible to obtain CBR encoding with custom buffer control. For example, to encode in canonical CBR mode use:

ffmpeg -i input -b 1000k -maxrate 1000k -bufsize 1000k [parameters] output.mp4

CBR encoding can be performed in single pass or multi pass. Single pass CBR is sufficiently efficient.

 VBR

libx264 supports two unconstrained VBR modes. In pure VBR you don’t know the final average bitrate of your video but you set a target quality (or quantization) that is applied by the encoder across the whole video.

-cqp sets a costant quantization for each frame. It is rarely useful.
-crf (Constant Rate Factor) sets a target quality factor and lets the encoder to change the quantization depending by frame type and sequence complexity. Adaptive Quantization and MB-Tree techniques change quantization at macroblock level according to macroblock importance. The -crf factor can usually be chosen in the range 18 (trasparent quality) to 30-35 (low quality, but the perceived quality depends by frame resolution and device dpi).

Usually VBR encoding is performed in single pass.


## SIMPLIFY YOUR LIFE USING PRESETS

Fortunately it is possible to avoid long command lines using pre-defined or custom encoding settings. Indeed I do not like very much this approach because there are a lot of cases when you need to have an accurate control over the parameters like in the case of HLS or HDS. But I recognise that the use of presets can save a lot of time in every-day works.

Profiles are simply a set of parameters enclosed in a profile file which you find in the ffpresets folder after unzipping the FFmpeg build package. Presets can change depending by the version of FFmpeg you have, so the best is to take a look at the content of the preset file. Commonly you will find a set of quality preset like libx264-hq.ffpreset or  libx264-slow.ffpreset , first pass presets like libx264-hq_firstpass.ffpreset and constraints presets like libx264-main.ffpreset or libx264-baseline.ffpreset 


So, to make a 2-pass encoding in baseline profile with the HQ preset you can use a command like this:

```cmd
ffmpeg -i INPUT -pass 1 -an -vcodec libx264 -vpre hq_firstpass -vpre baseline -b 1000k -s 640×360 OUTPUT.mp4
ffmpeg -i INPUT -pass 2 -acodec libfaac -ab 96k -ar 44100 -vcodec libx264 -vpre hq -b 1000k -vpre baseline -s 640×360 OUTPUT.mp4
```

(UPDATE: libfaac is now an external library and maybe you can have problem encoding in AAC – Read part V of the series to know more about this topic.)

Notice that the constrains preset is applyed with a second -vpre and that the first pass has the audio encoding disabled.
 Sometimes I have had problems with presets in Windows. You can bypass problems locating the presets simply using -fpre instead of -vpre. When using -fpre you must specify the absolute path to the preset file and not only the short name like in -vpre.

## UPDATE:

Since FFmpeg introduced a direct access to x264 parameters it is also possible to use native x264 profiles. ES:

ffmpeg -i INPUT -an -c:v libx264 -s 960×540 -x264opts preset=slow:tune=ssim:bitrate=1000 OUTPUT.mp4

## ENCODING FOR DIFFERENT DEVICES

Using the constraints presets it is possible to encode for mobile devices that usually require baseline profile to enable hardware acceleration. This limit is rapidly being surpassed by current hardware and operative systems. But if you need to target older devices (for example iOS 3 devices) and newer with the same video it’s still necessary to be able to generate easily video compliant to baseline profile. You find other generic raccomandations for multi device encoding here.

# FFmpeg for streaming  / Fourth Part

In this article I will focus on the support for RTMP that makes FFmpeg an excellent tool for enhancing the capabilities of the Adobe Flash Streaming Ecosystem.

FFmpeg introduced a strong support for RTMP streaming with the release 0.5 by the inclusion of the librtmp (rtmpdump) core. An RTMP stream can be used both as an input and/or as an output in a command line.

The required syntax is:

```cmd
rtmp_proto://server[:port][/application][/stream] options
```

where rtmp_proto can be: “rtmp“, “rtmpt“, “rtmpte“, “rtmps“, “rtmpte“, “rtmpts” and options contain a list of space-separated options in the form key=val (more info here).

Using some of the parameters that we have seen in the first three parts of the series, it’s possible to do a lot of things that the standard Flash Streaming Ecosystem cannot offer. Sometimes there are minor bugs but generally speaking the rtmplib works well and helps FMS to fill the gap with some advanced feature of Wowza Server (like re-purposing of rtp/rtsp stream, TS-stream and so on). FFmpeg works with FMS as well as Wowza Server and RED5, so in the article I will use FMS as a generic term to mean any “RTMP-server”.

## 1. STREAM A FILE TO FMS AS IF IT WERE LIVE

With the help of FFmpeg it is possible for example to stream a pre-encoded file to FMS as if it were a live source. This can be very useful for test purpose but also to create pseudo-live channels.

```cmd
ffmpeg -re -i localFile.mp4 -c copy -f flv rtmp://server/live/streamName
```

The -re option tells FFmpeg to read the input file in realtime and not in the standard as-fast-as-possible manner. With -c copy (alias -acodec copy -vcodec copy ) I’m telling FFmpeg to copy the essences of the input file without transcoding, then to package them in an FLV container (-f flv) and send the final bitstream to an rtmp destination (rtmp://server/live/streamName).

The input file must have audio and video codec compatible with FMS, for example H.264 for video and AAC for audio but any supported codecs combination should work.
 Obviously it would be also possible to encode on the fly the input video. In this case remember that the CPU power requested for a live encoding can be high and cause loss in frame rate or stuttering playback on subscribers’ side.

In which scenario can be useful a command like that ?

For example, suppose to have created a communication or conference tool in AIR. One of the partecipants at the conference could fetch a local file and stream it to the conference FMS to show, in realtime, the same file to other partecipants. Leveraging the “native process” feature of AIR it is simple to launch a command line like the one above and do the job. In this scenario, probably you will have to transcode the input, or check for the compatibility of codecs analyzing the input up front (remember ffmpeg -i INPUT trick we spoke about in the second article).

## 2. GRAB AN RTMP SOURCE

Using a command like this:
 
```cmd
ffmpeg -i rtmp://server/live/streamName -c copy dump.flv
```
 
It’s possible to dump locally the content of a remote RTMP stream. This can be useful for test/audit/validation purpose. It works for both live and on-demand content.

## 3. TRANSCODE LIVE RTMP TO LIVE RTMP

One of the more interesting scenario is when you want to convert a format to a different one for compatibility sake or to change the characteristics of the original stream.

Let’s suppose to have a Flash Player based app that do a live broadcast. You know that until FP11, Flash can only encode using the old Sorenson spark for video and NellyMoser ASAO or Speex for audio. You may use a live transcoding command to enhance the compression of the video transcoding from Sorenson to H.264:

```cmd
ffmpeg -i rtmp://server/live/originalStream -c:a copy -c:v libx264 -vpre slow -f flv rtmp://server/live/h264Stream
```
 
This could be useful to reduce bandwidth usage especially in live broadcasting where latency it’s not a problem.
 The next release of FMS will also offer support for the Apple HTTP Live Streaming (like Wowza already do). So it will be possible to use FMS to stream live to iOS device. But FMS does not transcode the stream essence, it performs only a repackaging or repurposing of the original essences. But FFmpeg can help us to convert the uncompliant Sorenson-Speex stream to a H.264-AAC stream in this way:

```cmd
ffmpeg -i rtmp://server/live/originalStream -c:a libfaac -ar 44100 -ab 48k -c:v libx264 -vpre slow -vpre baseline -f flv rtmp://server/live/h264Stream
```
 
(UPDATE: libfaac is now an external library and maybe you can have problem encoding in AAC – Read part V of the series to know more about this topic.)

See also the point 4 and 5 to know how to generate a multibitrate stream to be compliant with Apple requirements for HLS. This approach will be useful also with FP11 that encode in H.264, but generate only one stream.

Another common scenario is when you are using FMLE to make a live broadcast. The standard windows version of FMLE supports only MP3 and not AAC for audio encoding (plug-in required). This may be a problem when you want to use your stream also to reach iOS devices with FMS or Wowza (iOS requires AAC for HLS streams). Again FFmpeg can help us:



1
 
ffmpeg -i rtmp://server/live/originalStream -acodec libfaac -ar 44100 -ab 48k -vcodec copy -f flv rtmp://server/live/h264_AAC_Stream
 

On the other hand, I have had the opposite problem recently with an AIR 2.7+ apps for iOS. AIR for iOS does not support by now H.264 or AAC streaming with the classical netStream object, but I needed to subscribe AAC streams generated for the desktops. FFmpeg helped me in transcoding AAC streams to MP3 for the AIR on iOS app.

Again, you probably know that Apple HLS requires an audio only AAC stream with a bitrate less than 64Kbit/s for the compliance of video streaming apps, but at the same time you probably want to offer an higher audio quality for your live streaming (on desktop fpo istance). Unfortunately FMLE encode at multiple bitrates only the video track while use a unique audio preset for all bitrates. With FFmpeg is possible to generate a dedicated audio only stream in AAC with bitrate less than 64Kbit/s.

4. GENERATE BASELINE FOR LOW-END DEVICES

Very similarly, if you want to be compliant with older iOS versions or other mobile devices (older BB for istance) you need to encode in Baseline profile, but at the same time you may want to leverage high profile for desktop HDS. So you could use FMLE to generate high profile streams, with high quality AAC and then generate server side a baseline set of multi-bitrate streams for HLS and/or low end devices compatibility.

This command read from FMS the highest quality of a multi bitrate set generated by FMLE and starting from that generate 3 scaled down versions in baseline profile for HLS or Mobile. The last stream is an audio only AAC bitstream at 48Kbit/s.



1
 
ffmpeg -re -i rtmp://server/live/high_FMLE_stream -acodec copy -vcodec x264lib -s 640x360 -b 500k -vpre medium -vpre baseline rtmp://server/live/baseline_500k -acodec copy -vcodec x264lib -s 480x272 -b 300k -vpre medium -vpre baseline rtmp://server/live/baseline_300k -acodec copy -vcodec x264lib -s 320x200 -b 150k -vpre medium -vpre baseline rtmp://server/live/baseline_150k -acodec libfaac -vn -ab 48k rtmp://server/live/audio_only_AAC_48k
 

UPDATE: using the -x264opts parameter you may rewrite the command like this:



1
 
ffmpeg -re -i rtmp://server/live/high_FMLE_stream -c:a copy -c:v x264lib -s 640x360 -x264opts bitrate=500:profile=baseline:preset=slow rtmp://server/live/baseline_500k -c:a copy -c:v x264lib -s 480x272 -x264opts bitrate=300:profile=baseline:preset=slow rtmp://server/live/baseline_300k -c:a copy -c:v x264lib -s 320x200 -x264opts bitrate=150:profile=baseline:preset=slow rtmp://server/live/baseline_150k -c:a libfaac -vn -b:a 48k rtmp://server/live/audio_only_AAC_48k
 



(UPDATE: libfaac is now an external library and maybe you can have problem encoding in AAC – Read part V of the series to know more about this topic.)


5. ENCODE LIVE FROM LOCAL GRABBING DEVICES

FFmpeg can use also a local AV source, so it’s possible to encode live directly from FFmpeg and bypass completely FMLE. I suggest to do that only in very controlled scenarios because FMLE offers precious, addictional functions like auto-encoding adjust to keep as low as possible the latency when the bandwidth between the acquisition point and the server is not perfect.

This is an example of single bitrate:



1
 
ffmpeg -r 25 -f dshow -s 640x480 -i video="video source name":audio="audio source name" -vcodec libx264 -b 600k -vpre slow -acodec libfaac -ab 128k rtmp://server/application/stream_name
 

Join this command line and the previous and you have a multi-bitrate live encoding configuration for desktop and mobile.

6. ENCODE SINGLE PICTURES WITH H.264 INTRA COMPRESSION

H.264 has a very efficient Intra compression mode, so it is possible to leverage it for picture compression. I have estimated an improvement of around 50% in compression compared to JPG. Last year I have discussed estensively the possibility to use this kind of image compression to protect professional footage with FMS and RTMPE. Here you find the article, and this is the command line:



1
 
ffmpeg.exe -i INPUT.jpg -an -vcodec libx264 -coder 1 -flags +loop -cmp +chroma -subq 10 -qcomp 0.6 -qmin 10 -qmax 51 -qdiff 4 -flags2 +dct8x8 -trellis 2 -partitions +parti8x8+parti4x4 -crf 24 -threads 0 -r 25 -g 25 -y OUTPUT.mp4
 

Change -crf to modulate encoding quality (and compression rate).

UPDATES

Sometimes when connecting to FMS you may receive some cryptic error. It may help to enclose the destination RTMP address in double quotes and add the option live=1. ES:

ffmpeg -i rtmp://server/live/originalStream -c:a copy -c:v libx264 -vpre slow -f flv "rtmp://server/live/h264Stream live=1"
 
Other info on RTMP dump libray: http://ffmpeg.org/ffmpeg.html#toc-rtmp

CONCLUSIONS

There are a lot of other scenarios where using FFmpeg with FMS (or Wowza) can help you creating new exciting services for you projects and overcome the limitations of the current Flash Video Ecosystem, so now it’s up to you. Try to mix my examples and post comments about new ways of customization that you have found of your RTMP delivery system.
 Remember also to follow the discussion on my twitter account (@sonnati).


# Advanced usage 

Introduction

After almost one year from the starting post of this series dedicated to FFmpeg I have found some time to catch-up with this topic and revise/refresh the series. In this year a lot of things happened on the FFmpeg side (and not only), so I have corrected a lot of small errors and changes in syntax of commonly used commands. So this is also a good opportunity for you to refresh your knowledge about FFmpeg and the current state-of-the-art. Above you find the Index of the articles.

The most important changes are around parameters like -vcodec, -b, -ab, -vframes, etc… to avoid misunderstandings now a stream_identifier has been added to specify if the parameter is related to the audio or video track. In case of multiple AV tracks there also an optiona parameter to specify the track number. Take a look at the updates of PART II to have more informations about new syntax and obsolete parameters.

Another important change is realated to libfaac library which is now external. Read point 2 below to know about alternatives.

Last but not least, FFmpeg introduced the possibility to control directly the parameters of x264lib using the -x264opts command. Not for everyone but very useful when you want the control and performance of x264 and all the input and output options of FFmpeg.

Fifth Part – Advanced Usage

This fifth article wants to add more advanced use cases and usages to what was presented and discussed in the previous 4 parts. This article will be enriched in the next weeks and months to include even more advanced examples and use cases that can be solved with a smart use of FFmpeg. Good reading!

1. Optimize multi-pass multi-bitrates encoding

You know that encoding for dynamic streaming techniques (HDS, HLS, Silverlight) requires the renditions to have aligned keyframes and be CBR or capped VBR.
 A neat trick to avoid the limit of fixed length GOPs is to assure a consistent alignment of keyframes across renditions reusing the same first pass statfile across renditions.

ffmpeg –i IN –pass 1 –an –vcodec libx264 –r 30 –b 1500k –bufsize 1500k –keyint_min 60 –g 120 –s 1280×720 –vpre slower_fastfirstpass OUT_1500.mp4

This command line is the first pass of the first rendition. The first pass generates a stat file for the second pass.

ffmpeg –i IN –pass 2 –an –vcodec libx264 –r 30 –b 1500k –bufsize 1500k –keyint_min 60 –g 120 –s 1280×720 –vpre slower OUT_1500.mp4

Instead of recreating a first pass stat file for the next renditions, you can use the previous simply launching the second passes of the next renditions

ffmpeg –i IN –pass 2 –an –vcodec libx264 –r 30 –b 1000k –bufsize 1000k –keyint_min 60 –g 120 –s 854×480 –vpre slower O_1000.mp4
ffmpeg –i IN –pass 2 –an –vcodec libx264 –r 30 –b 500k –bufsize 500k –keyint_min 60 –g 120 –s 640×360 –vpre slower O_500.mp4

Since the second pass is less accurate if it use a stat file generated with a too much different resolution and bitrate, may be better to use a rendition in the middle to generate the first pass and not the highest rendition.

2. AAC encoding

libfaac has been extracted from ffmpeg and is now an external library. There are two alternatives yet embedded inside ffmpeg: libvo_aacenc or the standard aac library.

ffmpeg input.mp3 -c:a libvo_aacenc -b:a 96k -ac 2 -ar 44100 output.aac

ffmpeg input.mp3 -c:a aac -strict experimental -b:a 96k -ac 2 -ar 44100 output.aac

I have tested both and it seems to me that libvo is the best alternative. It produces a sufficiently good AAC LC.
 In a future article I’ll explore some alternative like encoding audio track externally and remux then with ffmpeg or mp4box.
 This is a must go if you need the higher efficiency of HE AAC or HE AAC v2.

3. Joining video

Joining video is strangely a complex task with FFmpeg. A reader suggested this solution (via Steven’s Blog):

ffmpeg -ss 100 -t 10 -i in.mp4 -c copy -bsf h264_mp4toannexb 100.h264

ffmpeg -ss 200 -t 10 -i in.mp4 -c copy -bsf h264_mp4toannexb 200.h264

ffmpeg -i concat:”100.h264|200.h264″ -i in.mp3 -c copy out.mp4


The first two lines generate two h.264 elementary streams. The h264_mp4toannexb option is mandatory to be able to concatenate efficiently elementary streams at binary level.

The third line use the concat option to cancatenate the ES segments to form a new input.
 I usually use mp4box for this kind of purpose and not FFmpeg.



 4. Use an HLS stream as source 

FFmpeg now supports also Apple HTTP Live Streaming as an input protocol. So it is really simple to acquire or repurpose an HLS streaming, simply specify the path to .m3u8 manifest.

ES: Do you want to stream an existing .m3u8 stream to Flash on the desktop using FMS (now AMS) ? Try this: 


1
 
ffmpeg -re -i http://server/path/stream.m3u8 -c copy -f flv "rtmp://FMSserver/app/streamName live=1"
 



 5. Record a stream endlessly rotating target file 

Segmenting feature of FFmpeg can also be useful to create an endless recorder with rotating buffer. It can be done using the segment_wrap parameter that wraps around segment index once it reached a limit.

ffmpeg -i rtmp://INPUT -codec copy -f segment -segment_list out.list -segment_time 3600 -segment_wrap 24 out%03d.mp4

The previous commandline records endlessly the INPUT stream in a ring buffer formed by 24 chunk of 1hr video.





# The fabulous world of FFmpeg  filtering

Transcoding is not a “static” matter, it is dynamic because you may have in input a very wide range of content’s types and you may have to set encoding parameters accordingly (This is particularly true for user generated contents).

Not only, the elaborations that you need to do in a video project may go beyond a simple transcoding and involve a deeper capacity of analysis, handling and “filtering” of video files.

Let’s consider some examples:

1. you have input files of several resolutions and aspect ratios and you have to encode them to two target output formats (one for 16:9 and one for 4:3) . In this case you need to analyze the input file and decide what profile to apply depending by input aspect ratio.

2. now let’s suppose you want also to encode video at the target resolution only if the input has an equal or higher resolution and keep the original otherwise. Again you’d need some external logic to read the metadata of the input and setup a dedicated encoding profile.

3. sometime video needs to be filtered, scaled and filtered again. Like , for istance, deinterlacing,  watermarking and denoising. You need to be able to specify a sequence of  filtering and/or manipulation tasks.

4. everybody needs thumbnails generation, but it’s difficult to find a shot really representative of the video content. Grabbing shots only on scene changes may be far more efficient.

FFmpeg can satisfy these kinds of complex analysis, handling and filtering tasks even without an external logic using the embedded filtering engine ( -vf ). For very complex workflows an external controller is still necessary but filters come handy when you need to do the job straight and simple.

FFmpeg filtering is a wide topic because there are hundreds of filters and thousands of combinations. So, using the same “recipe” style of the previous articles of this series, I’ll try to solve some common problems with specific command line samples focused on filtering. Note that to simplify command lines I’ll omit the parameters dedicated to H.264 and AAc encoding. Take a look at previous articles for such informations.

1. Adaptive Resize

In FFmpeg you can use the -s switch to set the resolution of the output but this is a not flexible solution. Far more control is provided by the filter “scale”.  The following command line scales the input to the desired resolution the same way as -s:



1
 
ffmpeg -i input.mp4 -vf  "scale=640:360" output.mp4
 

But scale provides you also with a way to specifing only the vertical or horizontal resolution and calculate the other to keep the same aspect ratio of the input:



1
 
ffmpeg -i input.mp4 -vf  "scale=640:-1" output.mp4
 

With -1 in the vertical resolution you delegate to FFmpeg the calculation of the right value to keep the same aspect ratio of input (default) or obtain the aspect radio specified with -aspect switch (if present). Unfortunately, depending by input resolution, this may end with a odd value or an even value witch is not divisable by 2 as requested by H.264. To enforce a “divisible by x” rule, you can simply use the emebedded expression evaluation engine:



1
 
ffmpeg -i input.mp4 -vf  "scale=640:trunc(ow/a/2)*2" output.mp4
 

The expression trunc(ow/a/2)*2 as vertical resolution means: use as output height the output width (ow = in this case 640) divided for input aspect ratio and approximated to the nearest multiple of 2 (I’m sure most of you are practiced with this kind of calculation).

2. Conditional resize

Let’s go further and find a solution to the problem 2 mentioned above: how to skip resize if the input resolution is lower than the target ?



1
 
ffmpeg -i input.mp4 -vf  "scale=min(640,iw):trunc(ow/a/2)*2" output.mp4
 

This command line uses as width the minimum between 640 and the input width (iw), and then scales the height to maintain the original aspect ratio. Notice that “,” may require to be escaped to “\,” in some shells.

With this kind of filtering you can easily setup a command line for massive batch transcoding that adapts smartly the output resolution to the target. Way to use the original resolution when lower than the target? Well, if you encode with -crf this may help you save alot of bandwidth!

3. Deinterlace

SD content is always interlaced and FullHD is very often interlaced. If you encode for the web you need to deinterlace and produce a progressive video which is also easier to compress. FFmpeg has a good deinterlacer filter named yadif (yet another deinterlacing filter) which is more efficient than the standard -deinterlace switch.



1
 
ffmpeg -i input.mp4 -vf  "yadif=0:-1:0, scale=trunc(iw/2)*2:trunc(ih/2)*2" output.mp4
 

This command deinterlace the source (only if it is interlaced) and then scale down to half the horizontal and vertical resolution. In this case the sequence is mandatory: always deinterlace prior to scale!

4. Interlacing aware scaling

Sometimes, especially if you work for ipTV projects, you may need to encode interlaced (this is because legacy STBs require interlaced contents and also because interlaced may have higher temporal resolution). This is simple, just add -tff or -bff (top field first or bottom field first) in the x264 parameters. But there’s a problem: when you start from a 1080i and want to go down to an interlaced SD output (576i or 480i) you need an interlacing aware scaling because a standard scaling will break the interlacing. No fear, recently FFmpeg has introduced this option in the scale filter:



1
 
ffmpeg -i input.mp4 -vf  "scale=720:576:-1" output.mp4
 

The third optional flag of filter is dedicated to interlace scaling. -1 means automatic detection, use 1 instead to force interlacing scaling.

5. Denoising

When seeking for an high compression ratio it is very useful to reduce the video noise of input. There are several possibilities, my preferite is the  hqdn3d filter (high quality de-noising 3d filter)



1
 
ffmpeg -i input.mp4 -vf  "yadif,hqdn3d=1.5:1.5:6:6,scale=640:360" output.mp4
 

The filter can denoise video using a spatial function (first two parameters set strength) and a temporal function (last two parameters). Depending by the type of source (level of motion) can be more useful the spatial or the temporal. Pay attention also to the order of the filters: deinterlace -> denoise ->  scaling is usually the best.

6. Select only specific frames from input

Sometime you need to control which frames are passed to the encoding stage or more simply change the Fps. Here you find some useful usages of the select filter:



1
 
ffmpeg -i input.mp4 -vf  "select=eq(pict_type,I)" output.mp4
 

This sample command filter out every frame that are not an I-frame. This is useful when you know the gop structure of the original and want to create in output a fast preview of the video. Specifing a frame rate for the output with -r accelerate the playback while using -vsync 0 will copy the pts from input and keep the playback real-time.

Note: The previous command is similar to the input switch -skip_frame nokey ( -skip_frame bidir drops b-frames instead during deconding, useful to speedup decoding of big files in special cases).


ffmpeg -i input.mp4 -vf  "select=not(mod(n,3))" output.mp4
 

This command selects a frame every 3, so it is possible to decimate original framerate by an integer factor N, useful for mobile low-bitrate encoding.

7. Speed-up or slow-down the video

It is also funny to play with PTS (presentation time stamps)

ffmpeg -i input.mp4 -vf  "setpts=0.5*PTS" output.mp4
 
Use this to speed-up your video of a factor 2 (frame are dropped accordingly), or this below to slow-down:

ffmpeg -i input.mp4 -vf  "setpts=2.0*PTS" output.mp4
 
8. Generate thumbnails on scene changes

The filter thumbnail tries to find the most representative frames in the video. Good to generate thumbnails.

ffmpeg -i input.mp4 -vf  "thumbnail,scale=640:360" -frames:v 1 thumb.png
 
A different way to achieve this is to use again select filter. The following command selects only frames that have more than 40% of changes compared to previous (and so probably are scene changes) and generates a sequence of 5 png.

ffmpeg -i input.mp4 -vf  "select=gt(scene,0.4),scale=640x:360" -frames:v 5 thumb%03d.png
 
## Conclusions

The world of FFmpeg filtering is very wide and this is only a quick and “filtered” view on this world

