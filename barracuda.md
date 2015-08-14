# Barracuda Web Application Firewall


- Clustering - How does config information propagate between multiple Barracida instances?
- How to automatically provision license and config into a cluster? Chef? 
- [How to Redirect Traffic to a Different Back-end Server Based on a URL Pattern](https://techlib.barracuda.com/WAF/RedirectTrafficBasedonURLPattern)
- [Barracuda on Azure](https://techlib.barracuda.com/WAF/Azure)

Cluster Secret on both machines
Decryption Password must be same
Templates fomr ARM are coming
Full reverse proxy
Username/password from portal are not used

Web GUI via admin/admin, and then change
port 8000 / 8443 for management
Advances/secure administration - change Web Interface SSL port
Map 443:443 and 8443:8443 initially

Import Certs PKCX12/PEM, don't forget intermediate certs

Basic / Services for forwarding. Servers under inbound rules

Websites / Website Translations

Clustering

Advances / High Availability
Join the empty WAF to the configured one

Advances / System Configuration
Encryption Key for Cookies

ARR under Basic Services
On Service or on Rule
Persistence Method: Cookie Insert

Export Config
Advanced Backup
Advanced / Template 

www.barracuda.com/evaluation down to the bottom Azure, do twice
Licensing is counting CPU cores, can run on A or D series

Active mode means WAF might block traffic, passive mode doesn't block security violations

# Licensing

Each WAF need