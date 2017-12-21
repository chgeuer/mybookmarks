# prefix file names in PowerShell

```
$prefix = "TR24"

dir *.* | foreach { Rename-Item $_.Name  "$($prefix) $($_.Name)" }
```


# bootable USB

```
diskpart
	list disk
	select disk #
	clean
	convert mbr
	create partition  primary
	select partition 1
	active
	format quick fs=fat32
	assign
	exit
bootsect /nt60 E:
xcopy F:\* E: /s /e
```



# Angular JS Links

- Angular directive to pull in user photos http://www.angularails.com/articles/creating_simple_directive_in_angular 
- http://msmvps.com/blogs/theproblemsolver/archive/2013/09/05/using-the-dom-in-an-angularjs-application.aspx
- http://www.yearofmoo.com/2013/09/advanced-testing-and-debugging-in-angularjs.html
- http://www.codeproject.com/Articles/637430/Angular-js-example-application
- http://weblogs.asp.net/dwahlin/archive/2013/09/16/the-angularjs-magazine-what-s-new-this-week.aspx
- http://solutionoptimist.com/2013/10/07/enhance-log-using-angularjs-decorators/
- http://ruoyusun.com/2013/08/24/a-glimpse-of-angularjs-scope-via-example.html
- http://flippinawesome.org/2013/09/03/the-angular-way/
- http://coderjournal.com/2013/07/angularjs-and-typescript/
- http://coderjournal.com/2013/07/signalr-and-angularjs/
- http://www.software-architects.com/devblog/2013/10/17/AngularJS-with-TypeScript-and-Windows-Azure-Mobile-Services
- http://www.script-tutorials.com/demos/359/index.html#!/project/product4
- http://www.jonathanbroquist.com/blog/2013/10/building-a-google-calendar-booking-app-with-mongodb-expressjs-angularjs-and-node-js-part-1/
- http://lostechies.com/gabrielschenker/2014/01/20/angluarjspart-10-intermezzo/



# JavaScript

- http://tech.pro/blog/1561/five-helpful-tips-when-using-requirejs
- http://tech.pro/tutorial/1559/knockoutjs-tips-and-tricks
- http://maroslaw.github.io/rainyday.js/demo2.html
- http://passportjs.org/
- https://github.com/DanWahlin/CustomerManager
- https://github.com/JohnMunsch/airquotes
- https://github.com/lukesampson/HastyAPI
- https://github.com/petkaantonov/bluebird
- Automatic page load progress bar http://github.hubspot.com/pace/

# Design

- http://designreviver.com/updates/surprisingly-friendly-colors-web-design/
- http://semantic-ui.com
- http://insideintercom.io/why-cards-are-the-future-of-the-web/
- http://www.sitepoint.com/getting-started-flat-ui-design/

# PHP

- http://blogs.msdn.com/b/vcblog/archive/2013/05/06/speeding-up-php-performance-for-your-application-using-profile-guided-optimization-pgo.aspx
- http://channel9.msdn.com/Shows/Web+Camps+TV/Learn-about-the-Performance-Improvements-in-PHP-on-Windows-from-Pierre-Joye-and-Stephen-Zarkos

# Video

- http://www.longtailvideo.com/html5/

Grunt, Bower, Angular, Knockout, Durandal, Breeze, Moment, Toastr, Backbone, Spin, Ember, React, Sencha, Dojo, Bootstrap, Pure

- Anonymous Pro - a fixed-width font designed for coders http://t.co/D8YnJsyGqG 
- Async File Uploads in MVC 4: http://weblogs.asp.net/bryansampica/archive/2013/01/15/AsyncMVCFileUpload.aspx
- 
- 
- http://architects.dzone.com/articles/implementing-signalr-stock
- http://benwilber.net/realtime-pixel-tracking-nginx-syslog-ng-redis
- http://bitwiseshiftleft.github.io/sjcl/demo/
- http://blog.coderstats.net/todomvc-complexity/
- http://blog.liamcavanagh.com/2012/06/how-to-use-paypal-with-asp-net-mvc/
- http://blog.ploeh.dk/2013/10/07/verifying-every-single-commit-in-a-git-branch/
- http://blogs.msdn.com/b/data_otaku/archive/2013/09/12/hadoop-for-net-developers-implementing-a-slightly-more-complex-mapreduce-job.aspx
- http://blogs.msdn.com/b/windowsazure/archive/2013/01/14/the-right-way-to-handle-azure-onstop-events.aspx
- http://blogs.windows.com/windows_phone/b/wpdev/archive/2013/09/17/windows-phone-webbrowser-control-tips.aspx
- http://download-center.dxo.com/FilmPack/v3/Win/DxO_FilmPack3_Setup.exe

- http://jeroenjanssens.com/2013/09/19/seven-command-line-tools-for-data-science.html
- http://seroter.wordpress.com/2012/07/17/installing-and-testing-the-new-service-bus-for-windows/
- http://startupteardown.com/post/62155822743/7-things-we-can-learn-from-bingo-card-creator
- http://tryghost.org/features.html
- http://www.bentobox.io/
- http://www.jeff.wilcox.name/2013/09/mongodb-azure-linux/
- http://www.script-tutorials.com/demos/359/index.html#!/project/product4
- http://www.troyhunt.com/2013/04/the-beginners-guide-to-breaking-website.html?report
- http://www.tugberkugurlu.com/archive/good-old-f5-experience-with-owinhost-exe-on-visual-studio-2013
- https://github.com/andreineculau/know-your-http-well
- htttp://www.zenit.de
- http://chrome.blogspot.com.au/2013/09/a-new-breed-of-chrome-apps.html
- http://tutorialzine.com/2013/10/12-awesome-css3-features-you-can-finally-use/
- http://www.bootstrapzero.com/
- http://procbits.com/2014/01/06/poor-mans-firebase-leveldb-rest-and-websockets
- http://fabriccontroller.net/blog/posts/passive-ftp-and-dynamic-ports-in-iis8-and-windows-azure-virtual-machines/
- http://www.windowsazure.com/en-us/documentation/articles/storage-windows-attach-disk/
- PEN Test beantragen http://download.microsoft.com/download/C/A/1/CA1E438E-CE2F-4659-B1C9-CB14917136B3/Penetration%20Test%20Questionnaire.docx
- Prozess: http://www.windowsazure.com/en-us/support/trust-center/security/
- http://scotch.io/bar-talk/bootstrap-3-tips-and-tricks-you-might-not-know



# Windows Tips

Turn on file sharing (admin shares) on Windows 8

```
[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System]
"LocalAccountTokenFilterPolicy"=dword:00000001
```

To access a share using a Microsoft account, use

```shell
NET USE X: \\192.168.0.5\c$ /USER:MicrosoftAccount\christian@outlook.de
```

## Get rid of Microsoft Advertisement SDK

```powershell
gwmi Win32_Product -Filter "Name LIKE 'Microsoft Advertising%'" | foreach { $_.Uninstall() }
```
