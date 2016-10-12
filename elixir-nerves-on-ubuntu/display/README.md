# Display Driver stuff


For the [Kuman 3.5 inch 320*480 Resolution Touch Screen TFT LCD Display](https://www.amazon.de/Kuman-Resolution-Display-Protective-Raspberry/dp/B01FX7909Q/)...


- https://github.com/raspberrypi/linux/blob/rpi-3.18.y/arch/arm/boot/dts/ads7846-overlay.dts
- [nerves_system_br](https://github.com/nerves-project/nerves_system_br/blob/master/README.md)
- [nerves_system_rpi3](https://github.com/nerves-project/nerves_system_rpi3/blob/master/README.md)
- [Getting a 5 inch XPT2046 based touch LCD working with Raspbian 7 and a Raspberry Pi 2](https://blog.ask-a.ninja/?p=48)
- [R-Pi configuration file](http://elinux.org/R-Pi_configuration_file#How_to_edit_from_a_Windows_PC)
- [How to Setup an LCD Touchscreen on the Raspberry Pi](http://www.circuitbasics.com/setup-lcd-touchscreen-raspberry-pi/)
- [Raspberry_Pi_5''_HDMI_LCD_Display_w/touch](http://www.electrodragon.com/w/Raspberry_Pi_5''_HDMI_LCD_Display_w/touch)
- [Embedded Elixir with Nerves and Bake](http://wsmoak.net/2016/01/11/embedded-elixir-nerves-bake.html)
- [Driving NeoPixels With Elixir and Nerves](http://www.gregmefford.com/blog/2016/01/22/driving-neopixels-with-elixir-and-nerves/)
- http://elinux.org/RPiconfig
- https://github.com/notro/rpi-firmware/issues/24
- https://github.com/raspberrypi/firmware/blob/master/boot/overlays/README#L133

ADS7846 works for XPT2046 

Just add the below additional lines to the configuration file (in /boot/config.txt when Raspbian is running):

```
dtparam=audio=on
dtoverlay=tft35a
dtoverlay=ads7846,cs=1,penirq=17,penirq_pull=2,speed=1000000,keep_vref_on=1,swapxy=1,pmax=255,xohms=60,xmin=200,xmax=3900,ymin=200,ymax=3900
```

To install the 3.5 inch screen, copy the following contents directly:


# `>> /etc/inttab`

```
#Spawn a getty on Raspberry Pi serial line
T0:23:respawn:/sbin/getty -L ttyAMA0 115200 vt100
```


# `/boot/cmdline.txt`

```
dwc_otg.lpm_enable=0 console=tty1 console=ttyAMA0,115200 root=/dev/mmcblk0p2 rootfstype=ext4 elevator=deadline rootwait fbcon=map:10 fbcon=font:ProFont6x11 logo.nologo
```

# `/boot/config.txt` 

```
hdmi_force_hotplug=1
dtparam=i2c_arm=on
dtparam=spi=on
enable_uart=1
dtparam=audio=on
dtoverlay=tft35a
dtoverlay=ads7846,cs=1,penirq=17,penirq_pull=2,speed=1000000,keep_vref_on=1,swapxy=1,pmax=255,xohms=60,xmin=200,xmax=3900,ymin=200,ymax=3900
```

# driver binaries

```
sudo cp ./usr/tft35a-overlay.dtb          /boot/overlays/tft35a-overlay.dtb
sudo cp ./usr/tft35a-overlay.dtb          /boot/overlays/tft35a.dtbo
```
