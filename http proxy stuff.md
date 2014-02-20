
Privoxy (the former Junkbuster) does not support proxy authentication
http://www.privoxy.org/user-manual/config.html#ENABLE-PROXY-AUTHENTICATION-FORWARDING 

nginx cannot be used as forward proxy with SSL, it can only terminate SSL in loadbalancer/reverse proxy scenarios
http://superuser.com/questions/604352/nginx-as-forward-proxy-for-https
http://forum.nginx.org/read.php?2,15124,15256#msg-15256

squid


http://mvideos-geo.daserste.de/videoportal/Film/c_390000/399251/format494753.mp4
http://cdn-sotschi.br.de/geo/b7/2014-02/18/3cfa88a698e911e3bca2984be109059a_C.mp4




Use CentOS Image

sudo su
yum update

# https://www.digitalocean.com/community/articles/how-to-install-squid-proxy-on-centos-6
yum -y install squid
yum -y install httpd-tools
chkconfig squid on

# http://dabase.com/blog/Minimal_squid3_proxy_configuration/
# http://www.squid-cache.org/Versions/v3/3.1/cfgman/



#
# add user named chgeuer to the chgeuerproxy realm
#
htdigest -c /etc/squid/passwords chgeuerproxy chgeuer


cat >> /etc/squid/squid.conf
auth_param digest program /usr/lib64/squid/digest_pw_auth -c /etc/squid/passwords
auth_param digest realm chgeuerproxy
acl authenticated proxy_auth REQUIRED
http_access allow authenticated
http_port 8080
# http://wiki.squid-cache.org/SquidFaq/ConfiguringSquid on "Can I make Squid proxy only, without caching anything"
cache deny all




http://www.squid-cache.org/Doc/config/forwarded_for/
X-Forwarded-For: delete


rm /var/run/squid.pid
/etc/init.d/squid start


