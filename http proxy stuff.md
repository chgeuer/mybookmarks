
# HTTP Proxies

## Privoxy

Privoxy (the former Junkbuster) does not support to authenticate clients via proxy authentication, it can only authenticate to upstream proxies: http://www.privoxy.org/user-manual/config.html#ENABLE-PROXY-AUTHENTICATION-FORWARDING 

## nginx

nginx cannot be used as forward proxy with SSL, because it does not handle CONNECT statements properly. It can only terminate SSL in loadbalancer/reverse proxy scenarios

- http://superuser.com/questions/604352/nginx-as-forward-proxy-for-https
- http://forum.nginx.org/read.php?2,15124,15256#msg-15256

## squid

squid 3.1 does not understand the request_header_add directive, so need to use squid

### Install squid 3.3

```shell
$ sudo su
$ yum update
$ yum -y install httpd-tools
$ yum -y install ksh
$
$ wget http://www1.ngtech.co.il/rpm/centos/6/x86_64/squid-3.3.11-1.el6.x86_64.rpm
$ rpm -ivh squid-3.3.11-1.el6.x86_64.rpm
```

### Configure squid

#### add user named chgeuer to the chgeuerproxy realm

```shell
$ htdigest -c /etc/squid/passwords chgeuerproxy chgeuer
```

#### Edit /etc/squid/squid.conf

```
# for squid 3.1
# auth_param digest program /usr/lib64/squid/digest_pw_auth -c /etc/squid/passwords
# for squid 3.3
auth_param digest program /usr/lib64/squid/digest_file_auth -c /etc/squid/passwords

auth_param digest realm chgeuerproxy
acl authenticated proxy_auth REQUIRED
http_access allow authenticated
# http://wiki.squid-cache.org/SquidFaq/ConfiguringSquid on "Can I make Squid proxy only, without caching anything"
cache deny all
# http://www.squid-cache.org/Doc/config/forwarded_for/
request_header_access X-Forwarded-For deny all
request_header_add X-Forwarded-For "192.168.0.13" all
http_access deny all
http_port 8080
```

#### Launch squid

```shell
/etc/init.d/squid start
```

### Further reference

- http://dabase.com/blog/Minimal_squid3_proxy_configuration/
- http://www.squid-cache.org/Versions/v3/3.1/cfgman/
