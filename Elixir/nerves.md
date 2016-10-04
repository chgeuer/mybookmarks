
# Nerves on Ubuntu

- http://www.zohaib.me/elixir-phoenix-framework-embedded-image-for-raspberry-pi-2/
- https://hub.docker.com/r/zabirauf/nerves-sdk-elixir/
- https://github.com/nerves-project/nerves_system_br
- https://github.com/nerves-project/nerves-examples
- https://github.com/zabirauf/Dockerfiles/blob/master/Nerves-SDK/Dockerfile
- http://www.gregmefford.com/blog/2016/01/22/driving-neopixels-with-elixir-and-nerves/
- https://github.com/GregMefford/nerves_neopixel
- http://www.cultivatehq.com/posts/compiling-and-testing-elixir-nerves-on-your-host-machine/
- https://github.com/CultivateHQ/cultivatarmobile

```
```

```
cmd /K "docker run --interactive --tty --rm elixir:1.3.3"
cmd /K "docker run --interactive --tty --rm elixir:1.3.3 /bin/bash"
```

## For burning your `.fw`-file on Windows

- copy `nerves-examples/hello_wifi/_images/rpi3/hello_wifi.fw` to your PC
- Download https://github.com/fhunleth/fwup/releases/download/v0.9.2/fwup.exe
- `fwup.exe -a -t complete -i hello_wifi.fw -d hello_wifi.img`
- Burn the `.img`-file to your SD card with [Win32DiskImager](https://sourceforge.net/projects/win32diskimager/files/latest/download)
