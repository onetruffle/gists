The default archiso doesn't contain `networkmanager` which we use by default.
Also, `iwd` is very user unfriendly and has bad defaults when it comes to
802.1x PEAP (eduroam)  configuration. So systemd-networkd it is.

### iwd
```
## /var/lib/iwd/eduroam.8021x (incomplete)
[Security]
EAP-Method=PEAP
EAP-Identity=eduroam@gwdg.de
EAP-PEAP-CACert=/etc/ssl/certs/T-TeleSec_GlobalRoot_Class_2.pem
EAP-PEAP-Phase2-Method=MSCHAPV2
EAP-PEAP-Phase2-Identity=user-name@uni-goettingen.de
EAP-PEAP-Phase2-Password=password
EAP-PEAP-ServerDomainMask=eduroam.gwdg.de
```

### wpa_supplicant
```
## /etc/wpa_supplicant.conf
## generated by eduroam cat
network={
    ssid="eduroam"
    key_mgmt=WPA-EAP
    pairwise=CCMP
    group=CCMP TKIP
    eap=PEAP
    ca_cert="/home/user/.config/cat_installer/ca.pem"
    identity="email"
    altsubject_match="DNS:eduroam.netaccess.umn.edu"
    phase2="auth=MSCHAPV2"
	password="password"
}
```

### systemd-networkd

```
## /etc/systemd/network/eduroam-umn.network (incomplete)
[Match]
Name=wlan0

[Network]
DHCP=yes
DNS=203.0.113.1 203.0.113.2 203.0.113.3
Domains=ip.linodeusercontent.com
IPv6PrivacyExtensions=false

Gateway=192.0.2.1
Address=192.0.2.123/24
```