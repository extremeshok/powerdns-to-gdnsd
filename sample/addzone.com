; eXtremeSHOK.com PowerDNS to gdnsd migration script
; Copyright (c) Adrian Jon Kriel :: admin@extremeshok.com

$TTL 3600
$ORIGIN addzone.com.
@  1D  IN SOA  ns1.addzone.com.  ahu.example.com.  (
  1201604290  ; serial
  28800  ; refresh
  7200  ; retry
  604800  ; expire
  900  ; ncache
  )

; Address records

blah  3600  IN  A    192.168.6.1
b.c  3600  IN  A    5.6.7.8
*.a.b.c  3600  IN  A    8.7.6.5
smtp-servers  3600  IN  A    4.3.2.1
smtp-servers  3600  IN  A    5.6.7.8
ns1  3600  IN  A    1.1.1.5
ns2  3600  IN  A    2.2.2.2
server1  3600  IN  A    1.2.3.4
www.test  3600  IN  A    4.3.2.1
counter  3600  IN  A    1.1.1.5

; Canonical name records

within-server  3600  IN  CNAME    outpost.example.com.
www  3600  IN  CNAME    server1.addzone.com.
*.test  3600  IN  CNAME    server1.addzone.com.

; Mail exchangers

@  14400  IN  MX  10  smtp-servers.example.com.
@  14400  IN  MX  15  smtp-servers.addzone.com.

; NAPTR

enum  3600  IN  NAPTR    100 50 "u" "e2u+sip" "" testuser.domain.com.

; Name server records

blah  84600  IN  NS    blah.addzone.com.
@  84600  IN  NS    ns1.addzone.com.
@  84600  IN  NS    ns2.addzone.com.

; Service locators

_double._tcp.dc  3600  IN  SRV  1  100 389 server1.addzone.com.
_root._tcp.dc  3600  IN  SRV  0  0 0 .
_ldap._tcp.dc  3600  IN  SRV  0  100 389 server2.example.net.
_double._tcp.dc  3600  IN  SRV  0  100 389 server1.addzone.com.

; Text records : DKIM/DMARC/SPF/DNS-SD/etc.

very-long-txt  3600  IN  TXT    "A very long TXT record! boy you won't believe how long. A very long TXT record! boy you won't believe how long. A very long TXT record! boy you won't believe how long. A very long TXT record! boy you won't believe how long. A very long TXT record! boy you won't believe how long!"
_underscore  3600  IN  TXT    "underscores are terrible"
aland  3600  IN  TXT    "\195\133LAND ISLANDS"
hightxt  3600  IN  TXT    "v=spf1 mx ip4:78.46.192.210 –all"
