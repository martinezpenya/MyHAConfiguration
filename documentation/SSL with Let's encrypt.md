# SSL with [Let's encrypt](https://letsencrypt.org/):
1. Create a DYNHOST in OVH. Details:

    1. [OVH guide](https://docs.ovh.com/es/domains/web_hosting_dynhost)
    1. [ddclient](https://blog.ichasco.com/ddns-con-ovh/)

1. Redirect ports:
    1. Port 80 (external) to 80 (internal). We can change this one later after Let's encrypt verification (80 external --> 8123 internal)
    1. Port 443 (external) to 8123 (internal)

1. Install [certbot](https://certbot.eff.org/ ):
    ```sh
    sudo apt-get install certbot
    ```

1. If you have another https server, stop it. In my case I have lighttpd for pi-hole, so:
    ```sh
    sudo systemctl stop lighttpd.service
    ```

1. Download new Certificate:
    ```sh
    sudo certbot certonly --standalone
    ```

1. When you need to renew the Certificate:
    1. Port 80 (external) to 80 (internal) we can remove this one later after Let's encrypt renewal
    1. If you have another https server, stop it.
    1. then...
    ```sh
    cd ~/certbot
    sudo certbot renew --quiet --no-self-upgrade --standalone --preferred-challenges http-01
    ```

    1. Restart HA

1. Change permissions to `/etc/letsencrypt/live` and `/etc/letsencrypt/archive` folders

    ```sh
    sudo chmod 755 live archive -R
    ```

1. Change `configuration.yaml`:
    ```yaml
    http:
        base_url: https://###yourdomain###
        server_port: 8123
        ssl_certificate: /etc/letsencrypt/live/###yourdomain###/fullchain.pem
        ssl_key: /etc/letsencrypt/live/###yourdomain###/privkey.pem
    ```

1. In case you stopped lighttpd... restart the service
    ```sh
    sudo systemctl start lighttpd.service
    ```