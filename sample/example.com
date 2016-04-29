; eXtremeSHOK.com PowerDNS to gdnsd migration script
; Copyright (c) Adrian Jon Kriel :: admin@extremeshok.com

$TTL 3600
$ORIGIN example.com.
@  1D  IN SOA  ns1.example.com.  ahu.example.com.  (
  1201604290  ; serial
  28800  ; refresh
  7200  ; retry
  604800  ; expire
  900  ; ncache
  )

; Address records

ns1  120  IN  A    192.168.1.1
ns2  120  IN  A    192.168.1.2
double  120  IN  A    192.168.5.1
hightype  120  IN  A    192.168.1.5
localhost  120  IN  A    127.0.0.1
smtp-servers  120  IN  A    192.168.0.2
smtp-servers  120  IN  A    192.168.0.3
smtp-servers  120  IN  A    192.168.0.4
outpost  120  IN  A    192.168.2.1
*.w5  120  IN  A    1.2.3.5
start4  120  IN  A    192.168.2.2
usa-ns1.usa  120  IN  A    192.168.4.1
usa-ns2.usa  120  IN  A    192.168.4.2
italy-ns1  120  IN  A    192.168.5.1
italy-ns2  120  IN  A    192.168.5.2
host.*.sub  120  IN  A    192.168.6.1
toomuchinfo-a  120  IN  A    192.168.99.1
toomuchinfo-a  120  IN  A    192.168.99.2
toomuchinfo-a  120  IN  A    192.168.99.3
toomuchinfo-a  120  IN  A    192.168.99.4
toomuchinfo-a  120  IN  A    192.168.99.5
toomuchinfo-a  120  IN  A    192.168.99.6
toomuchinfo-a  120  IN  A    192.168.99.7
toomuchinfo-a  120  IN  A    192.168.99.8
toomuchinfo-a  120  IN  A    192.168.99.9
toomuchinfo-a  120  IN  A    192.168.99.10
toomuchinfo-a  120  IN  A    192.168.99.11
toomuchinfo-a  120  IN  A    192.168.99.12
toomuchinfo-a  120  IN  A    192.168.99.13
toomuchinfo-a  120  IN  A    192.168.99.14
toomuchinfo-a  120  IN  A    192.168.99.15
toomuchinfo-a  120  IN  A    192.168.99.16
toomuchinfo-a  120  IN  A    192.168.99.17
toomuchinfo-a  120  IN  A    192.168.99.18
toomuchinfo-a  120  IN  A    192.168.99.19
toomuchinfo-a  120  IN  A    192.168.99.20
toomuchinfo-a  120  IN  A    192.168.99.21
toomuchinfo-a  120  IN  A    192.168.99.22
toomuchinfo-a  120  IN  A    192.168.99.23
toomuchinfo-a  120  IN  A    192.168.99.24
toomuchinfo-a  120  IN  A    192.168.99.25
toomuchinfo-b  120  IN  A    192.168.99.26
toomuchinfo-b  120  IN  A    192.168.99.27
toomuchinfo-b  120  IN  A    192.168.99.28
toomuchinfo-b  120  IN  A    192.168.99.29
toomuchinfo-b  120  IN  A    192.168.99.30
toomuchinfo-b  120  IN  A    192.168.99.31
toomuchinfo-b  120  IN  A    192.168.99.32
toomuchinfo-b  120  IN  A    192.168.99.33
toomuchinfo-b  120  IN  A    192.168.99.34
toomuchinfo-b  120  IN  A    192.168.99.35
toomuchinfo-b  120  IN  A    192.168.99.36
toomuchinfo-b  120  IN  A    192.168.99.37
toomuchinfo-b  120  IN  A    192.168.99.38
toomuchinfo-b  120  IN  A    192.168.99.39
toomuchinfo-b  120  IN  A    192.168.99.40
toomuchinfo-b  120  IN  A    192.168.99.41
toomuchinfo-b  120  IN  A    192.168.99.42
toomuchinfo-b  120  IN  A    192.168.99.43
toomuchinfo-b  120  IN  A    192.168.99.44
toomuchinfo-b  120  IN  A    192.168.99.45
toomuchinfo-b  120  IN  A    192.168.99.46
toomuchinfo-b  120  IN  A    192.168.99.47
toomuchinfo-b  120  IN  A    192.168.99.48
toomuchinfo-b  120  IN  A    192.168.99.49
toomuchinfo-b  120  IN  A    192.168.99.50
toomuchinfo-b  120  IN  A    192.168.99.66
toomuchinfo-b  120  IN  A    192.168.99.67
toomuchinfo-b  120  IN  A    192.168.99.68
toomuchinfo-b  120  IN  A    192.168.99.69
toomuchinfo-b  120  IN  A    192.168.99.70
toomuchinfo-b  120  IN  A    192.168.99.71
toomuchinfo-b  120  IN  A    192.168.99.72
toomuchinfo-b  120  IN  A    192.168.99.73
toomuchinfo-b  120  IN  A    192.168.99.74
toomuchinfo-b  120  IN  A    192.168.99.75
toomuchinfo-b  120  IN  A    192.168.99.76
toomuchinfo-b  120  IN  A    192.168.99.77
toomuchinfo-b  120  IN  A    192.168.99.78
toomuchinfo-b  120  IN  A    192.168.99.79
toomuchinfo-b  120  IN  A    192.168.99.80
toomuchinfo-b  120  IN  A    192.168.99.81
toomuchinfo-b  120  IN  A    192.168.99.82
toomuchinfo-b  120  IN  A    192.168.99.83
toomuchinfo-b  120  IN  A    192.168.99.84
toomuchinfo-b  120  IN  A    192.168.99.85
toomuchinfo-b  120  IN  A    192.168.99.86
toomuchinfo-b  120  IN  A    192.168.99.87
toomuchinfo-b  120  IN  A    192.168.99.88
toomuchinfo-b  120  IN  A    192.168.99.89
toomuchinfo-b  120  IN  A    192.168.99.90
host-0  120  IN  A    192.168.1.0
host-1  120  IN  A    192.168.1.1
host-2  120  IN  A    192.168.1.2
host-3  120  IN  A    192.168.1.3
host-4  120  IN  A    192.168.1.4
host-5  120  IN  A    192.168.1.5
host-6  120  IN  A    192.168.1.6
host-7  120  IN  A    192.168.1.7
host-8  120  IN  A    192.168.1.8
host-9  120  IN  A    192.168.1.9
host-10  120  IN  A    192.168.1.10
host-11  120  IN  A    192.168.1.11
host-12  120  IN  A    192.168.1.12
host-13  120  IN  A    192.168.1.13
host-14  120  IN  A    192.168.1.14
host-15  120  IN  A    192.168.1.15
host-16  120  IN  A    192.168.1.16
host-17  120  IN  A    192.168.1.17
host-18  120  IN  A    192.168.1.18
host-19  120  IN  A    192.168.1.19
host-20  120  IN  A    192.168.1.20
host-21  120  IN  A    192.168.1.21
host-22  120  IN  A    192.168.1.22
host-23  120  IN  A    192.168.1.23
host-24  120  IN  A    192.168.1.24
host-25  120  IN  A    192.168.1.25
host-26  120  IN  A    192.168.1.26
host-27  120  IN  A    192.168.1.27
host-28  120  IN  A    192.168.1.28
host-29  120  IN  A    192.168.1.29
host-30  120  IN  A    192.168.1.30
host-31  120  IN  A    192.168.1.31
host-32  120  IN  A    192.168.1.32
host-33  120  IN  A    192.168.1.33
host-34  120  IN  A    192.168.1.34
host-35  120  IN  A    192.168.1.35
host-36  120  IN  A    192.168.1.36
host-37  120  IN  A    192.168.1.37
host-38  120  IN  A    192.168.1.38
host-39  120  IN  A    192.168.1.39
host-40  120  IN  A    192.168.1.40
host-41  120  IN  A    192.168.1.41
host-42  120  IN  A    192.168.1.42
host-43  120  IN  A    192.168.1.43
host-44  120  IN  A    192.168.1.44
host-45  120  IN  A    192.168.1.45
host-46  120  IN  A    192.168.1.46
host-47  120  IN  A    192.168.1.47
host-48  120  IN  A    192.168.1.48
host-49  120  IN  A    192.168.1.49
host-50  120  IN  A    192.168.1.50
host-51  120  IN  A    192.168.1.51
host-52  120  IN  A    192.168.1.52
host-53  120  IN  A    192.168.1.53
host-54  120  IN  A    192.168.1.54
host-55  120  IN  A    192.168.1.55
host-56  120  IN  A    192.168.1.56
host-57  120  IN  A    192.168.1.57
host-58  120  IN  A    192.168.1.58
host-59  120  IN  A    192.168.1.59
host-60  120  IN  A    192.168.1.60
host-61  120  IN  A    192.168.1.61
host-62  120  IN  A    192.168.1.62
host-63  120  IN  A    192.168.1.63
host-64  120  IN  A    192.168.1.64
host-65  120  IN  A    192.168.1.65
host-66  120  IN  A    192.168.1.66
host-67  120  IN  A    192.168.1.67
host-68  120  IN  A    192.168.1.68
host-69  120  IN  A    192.168.1.69
host-70  120  IN  A    192.168.1.70
host-71  120  IN  A    192.168.1.71
host-72  120  IN  A    192.168.1.72
host-73  120  IN  A    192.168.1.73
host-74  120  IN  A    192.168.1.74
host-75  120  IN  A    192.168.1.75
host-76  120  IN  A    192.168.1.76
host-77  120  IN  A    192.168.1.77
host-78  120  IN  A    192.168.1.78
host-79  120  IN  A    192.168.1.79
host-80  120  IN  A    192.168.1.80
host-81  120  IN  A    192.168.1.81
host-82  120  IN  A    192.168.1.82
host-83  120  IN  A    192.168.1.83
host-84  120  IN  A    192.168.1.84
host-85  120  IN  A    192.168.1.85
host-86  120  IN  A    192.168.1.86
host-87  120  IN  A    192.168.1.87
host-88  120  IN  A    192.168.1.88
host-89  120  IN  A    192.168.1.89
host-90  120  IN  A    192.168.1.90
host-91  120  IN  A    192.168.1.91
host-92  120  IN  A    192.168.1.92
host-93  120  IN  A    192.168.1.93
host-94  120  IN  A    192.168.1.94
host-95  120  IN  A    192.168.1.95
host-96  120  IN  A    192.168.1.96
host-97  120  IN  A    192.168.1.97
host-98  120  IN  A    192.168.1.98
host-99  120  IN  A    192.168.1.99
double  120  IN  A    192.168.5.1

; IPv6 Address records

ipv6  120  IN  AAAA    2001:6A8:0:1:210:4BFF:FE4B:4C61

; Canonical name records

www  120  IN  CNAME    outpost.example.com.
unauth  120  IN  CNAME    no-idea.example.org.
nxd  120  IN  CNAME    nxdomain.example.com.
start  120  IN  CNAME    x.y.z.w1.example.com.
*.w1  120  IN  CNAME    x.y.z.w2.example.com.
*.w2  120  IN  CNAME    x.y.z.w3.example.com.
*.w3  120  IN  CNAME    x.y.z.w4.example.com.
*.w4  120  IN  CNAME    x.y.z.w5.example.com.
start1  120  IN  CNAME    start2.example.com.
start2  120  IN  CNAME    start3.example.com.
start3  120  IN  CNAME    start4.example.com.
external  120  IN  CNAME    somewhere.else.net.
semi-external  120  IN  CNAME    bla.something.wtest.com.
server1  120  IN  CNAME    server1.france.example.com.
smtp1  120  IN  CNAME    outpost.example.com.
rhs-at-expansion  120  IN  CNAME    example.com.

; DS

; dsdelegation  120  IN  DS    28129 8 1 caf1eaaecdabe7616670788f9022454bf5fd9fda

; EUI48

; host-0  120  IN  EUI48    00-50-56-9b-00-e7

; EUI64

; host-1  120  IN  EUI64    00-50-56-9b-00-e7-7e-57

; HINFO

; hwinfo  120  IN  HINFO    "abc" "def"

; LOC

; location  120  IN  LOC    51 56 0.123 N 5 54 0.000 E 4.00m 1.00m 10000.00m 10.00m
; location  120  IN  LOC    51 56 1.456 S 5 54 0.000 E 4.00m 2.00m 10000.00m 10.00m
; location  120  IN  LOC    51 56 2.789 N 5 54 0.000 W 4.00m 3.00m 10000.00m 10.00m
; location  120  IN  LOC    51 56 3.012 S 5 54 0.000 W 4.00m 4.00m 10000.00m 10.00m

; Mail exchangers

@  14400  IN  MX  10  smtp-servers.example.com.
@  14400  IN  MX  15  smtp-servers.test.com.
mail  14400  IN  MX  25  smtp1.example.com.
external-mail  14400  IN  MX  25  server1.test.com.
together-too-much  14400  IN  MX  25  toomuchinfo-a.example.com.
together-too-much  14400  IN  MX  25  toomuchinfo-b.example.com.

; Name server records

@  84600  IN  NS    ns1.example.com.
@  84600  IN  NS    ns2.example.com.
france  84600  IN  NS    ns1.otherprovider.net.
france  84600  IN  NS    ns2.otherprovider.net.
usa  84600  IN  NS    usa-ns1.usa.example.com.
usa  84600  IN  NS    usa-ns2.usa.example.com.
italy  84600  IN  NS    italy-ns1.example.com.
italy  84600  IN  NS    italy-ns2.example.com.

; Text records : DKIM/DMARC/SPF/DNS-SD/etc.

text  120  IN  TXT    "Hi, this is some text"
multitext  120  IN  TXT    "text part one" "text part two" "text part three"
escapedtext  120  IN  TXT    "begin" "the \"middle\" p\\art" "the end"
text0  120  IN  TXT    "k=rsa; p=one"
text1  120  IN  TXT    "k=rsa\; p=one"
text2  120  IN  TXT    "k=rsa\\; p=one"
text3  120  IN  TXT    "k=rsa\\\; p=one"

; TYPE65534

; hightype  120  IN  TYPE65534    \# 5 07ED260001
