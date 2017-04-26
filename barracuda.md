# Barracuda Web Application Firewall

## Licensing

- Each WAF machine needs an own license. 
- License (Level 1 / 5 / 10 / 15) is for CPU Core count 1 / 2 / 4 / 8 respectively, can be deployed to A-series and D-Series. D-Series has better throughput.
- Get 2 Eval Licenses for "Barracuda Web Application Firewall Azure" can be retrieved from http://www.barracuda.com/evaluation. Repeat twice for "Level 15" Evals. After filling the form, send mail to Joeri Van Hoof <jvanhoof> and Bastian Majewski <bmajewski> so they can make sure we have them by the weekend. 

## Setup

- Provisioning through ARM should be possible, detailed templates come later
- TCP Ports: 
	- On the NLB, map 80/443/8000/8443 into a load-balanced set. 
- Initial setup
	- Connect to https://...:443. 
	- Login via `admin`/`admin`, change password. The username/password from the Azure provisioning are not used. 
	- Under "Advanced / Secure Administration", change management port from 443 to 8443
	- Re-Connect to https://...:8443. 
- *Clustering*
	- For clustering, first do configuration through web GUI on one machine. Under "Advanced / High Avaiability", then join second (empty) WAF machine to existing (configured) machine. Other way round destroys existing config. 
	- Under "Advanced / System Configuration", set same cluster key (so machines can talk to each other)
	- Under "Advanced / System Configuration", set same Encryption Key (so machines can decrypt each other's cookies)
- *X509 Certs*: Import Certs in PKCX12/PEM format, don't forget intermediate certs
- *Rules*
	- Under "Basic / Services", we can determine inbound rules which servers get load. 
	- Under "Basic / Services", configure a "persistence method = cookie insert" to enable ARR-style session affinity
	- Under "Websites / Website Translations", we can do rewriting, such as directing "/cms" requests to Polopoly GUI
- Backup
	- Under "Advanced / Backup" we can fully backup the config
	- Under "Advanced / Template" we can export selected config parts
- Security Enforcement
	- Recommendation is to have WAF configured as "passive", which only logs potential security issues. 
	- After a couple of weeks and careful inspection can be turned into "Active", which then actively blocks threats. 

## LInks

- [Barracuda on Azure](https://techlib.barracuda.com/WAF/Azure)
- [How to Redirect Traffic to a Different Back-end Server Based on a URL Pattern](https://techlib.barracuda.com/WAF/RedirectTrafficBasedonURLPattern)


