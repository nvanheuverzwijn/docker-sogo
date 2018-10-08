# SOGo

This repository is a docker image for [SOGo](https://sogo.nu/).

## Build and Run

Start the server:
```
docker build . -t sogo
docker run --rm --name sogo sogo
```

Start a shell inside the container:
```
docker exec -it sogo bash
```

## Users
List of users created in this container
### sogo
Created by `sogo` package

## Environment Variable
### SOGO_CONF
The content of this variable will override everything in `/etc/sogo/sogo.conf` if it is not empty.
### NGINX_CONF
Contains the nginx configuration. this variable will overwrite everything in `/etc/nginx/conf.d/default.conf` if not empty.

## Example
### Docker-compose
```
version: '3'
services:
  sogo:
    image: nvanheuverzwijn/sogo
    ports:
      - "8080:8080"
    environment:
      SOGO_CONF: |
        {
          SOGoProfileURL = "mysql://user:password@mariadb:3306/sogo/sogo_user_profile";
          OCSFolderInfoURL = "mysql://user:password@mariadb:3306/sogo/sogo_folder_info";
          OCSSessionsFolderURL = "mysql://user:password@mariadb:3306/sogo/sogo_sessions_folder";
          OCSEMailAlarmsFolderURL = "mysql://user:password@mariadb:3306/sogo/sogo_alarms_folder";
          SOGoLanguage = English;
          SOGoAppointmentSendEMailNotifications = YES;
          SOGoMailingMechanism = smtp;
          SOGoSMTPServer = postfix;
          SOGoTimeZone = UTC;
          SOGoSentFolderName = Sent;
          SOGoTrashFolderName = Trash;
          SOGoDraftsFolderName = Drafts;
          SOGoIMAPServer = "imaps://dovecot:143/?tls=YES";
          SOGoSieveServer = "sieve://dovecot:4190/?tls=YES";
          SOGoIMAPAclConformsToIMAPExt = YES;
          SOGoVacationEnabled = NO;
          SOGoForwardEnabled = NO;
          SOGoSieveScriptsEnabled = NO;
          SOGoFirstDayOfWeek = 0;
          SOGoMailMessageCheck = manually;
          SOGoMailAuxiliaryUserAccountsEnabled = NO;
          SOGoMemcachedHost = memcached;
        }
      NGINX_CONF: |
        server {
          listen 443;
          root /usr/lib/GNUstep/SOGo/WebServerResources/;
          server_name mail.domain.com
          server_tokens off;
          client_max_body_size 100M;
          index  index.php index.html index.htm;
          autoindex off;
          ssl on;
          ssl_certificate path /path/to/your/certfile; #eg. /etc/ssl/certs/keyfile.crt
          ssl_certificate_key /path/to/your/keyfile; #eg /etc/ssl/private/keyfile.key
          ssl_session_cache shared:SSL:10m;
          resolver 127.0.0.11 valid=300s;
          ssl_prefer_server_ciphers on;
          location = / {
                  rewrite ^ https://$$server_name/SOGo;
                  allow all;
          }
          location = /principals/ {
                  rewrite ^ https://$$server_name/SOGo/dav;
                  allow all;
          }
          location ^~/SOGo {
                  proxy_pass http://127.0.0.1:20000;
                  proxy_redirect http://127.0.0.1:20000 default;
                  # forward user's IP address
                  proxy_set_header X-Real-IP $$remote_addr;
                  proxy_set_header X-Forwarded-For $$proxy_add_x_forwarded_for;
                  proxy_set_header Host $$host;
                  proxy_set_header x-webobjects-server-protocol HTTP/1.0;
                  proxy_set_header x-webobjects-remote-host 127.0.0.1;
                  proxy_set_header x-webobjects-server-name $$server_name;
                  proxy_set_header x-webobjects-server-url $$scheme://$$host;
                  proxy_connect_timeout 90;
                  proxy_send_timeout 90;
                  proxy_read_timeout 90;
                  proxy_buffer_size 4k;
                  proxy_buffers 4 32k;
                  proxy_busy_buffers_size 64k;
                  proxy_temp_file_write_size 64k;
                  client_max_body_size 50m;
                  client_body_buffer_size 128k;
                  break;
          }
          location /SOGo.woa/WebServerResources/ {
                  alias /usr/lib/GNUstep/SOGo/WebServerResources/;
                  allow all;
          }
          location /SOGo/WebServerResources/ {
                  alias /usr/lib/GNUstep/SOGo/WebServerResources/;
                  allow all;
          }
          location ^/SOGo/so/ControlPanel/Products/([^/]*)/Resources/(.*)$$ {
                  alias /usr/lib/GNUstep/SOGo/$$1.SOGo/Resources/$$2;
          }
          location ^/SOGo/so/ControlPanel/Products/[^/]*UI/Resources/.*\.(jpg|png|gif|css|js)$$ {
                  alias /usr/lib/GNUstep/SOGo/$$1.SOGo/Resources/$$2;
          }
        }
```
