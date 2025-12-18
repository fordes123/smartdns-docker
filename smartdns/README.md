# smartdns-docker

Building a SmartDNS Docker image with a full Shunt Configuration and automatic updates for GeoSite lists.

[https://hub.docker.com/r/fordes123/smartdns](https://hub.docker.com/r/fordes123/smartdns)

## Usage

#### docker-compose

```shell
services:
  smartdns:
    image: fordes123/smartdns:latest
    container_name: smartdns
    volumes:
      - /path/to/smartdns:/etc/smartdns
    environment:
      - UPDATE_INTERVAL=0 0 */7 * *
    ports:
      - 53:53/udp
      - 53:53/tcp
    restart: unless-stopped
```

#### docker cli

```shell
docker run -d \
  --name smartdns \
  --restart unless-stopped \
  --env UPDATE_INTERVAL='0 0 */7 * *' \
  -v /path/to/smartdns:/etc/smartdns \
  -p 53:53/udp \
  -p 53:53/tcp \
  fordes123/smartdns:latest
```

### Parameters

| Parameter	                       | Function                                 
|:---------------------------------|:-----------------------------------------|
| `-p 53`                          | DNS port.                                
| `-v /etc/smartdns`               | config path.                             
| `-e UPDATE_INTERVAL=0 0 */7 * *` | auto update geosite rule cron expression 

---

### Acknowledgments

- [smartdns](https://github.com/pymumu/smartdns)
- [v2ray-rules-dat](https://github.com/Loyalsoldier/v2ray-rules-dat)