Install Jekyll on Windows
========================

- Install [rubyinstaller-2.0.0-p353-x64.exe](http://rubyinstaller.org/downloads/) to C:\Ruby200
- Extract [DevKit-mingw64-64-4.7.2-20130224-1432-sfx.exe](http://cdn.rubyinstaller.org/archives/devkits/DevKit-mingw64-64-4.7.2-20130224-1432-sfx.exe) to c:\Ruby200\devkit
- Add C:\Ruby200\bin to PATH


```Batch
CD /d c:\Ruby200\devkit
ruby dk.rb init
```

- Ensure "C:\Ruby200\devkit\config.yml" contains this:

```
---
- C:/Ruby200
```

Then run

```Batch
ruby dk.rb install
gem install directory_watcher
gem install wdm
gem install jekyll --version "=1.4.2"
```

Finally, to ensure Jekyll understands UTF-8 files (save UTF8, *not* UTF8-BOM)

```Batch
chcp 65001
call jekyll serve --watch --trace
```

