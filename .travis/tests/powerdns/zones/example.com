$TTL 120
$ORIGIN example.com.
@	100000	IN	SOA	ns1.example.com.	ahu.example.com. (
			2847484148
			8H ; refresh
			2H ; retry
			1W ; expire
			1D ; default_ttl
			)

@			IN	NS	ns1.example.com.
@			IN	NS	ns2.example.com.
@			IN	MX	10	smtp-servers.example.com.
@			IN	MX	15	smtp-servers.test.com.
;@			IN	DNSKEY  256 3 5 AwEAAarTiHhPgvD28WCN8UBXcEcf8f+OF+d/bEoN6zTuHl/oVra5/qfonhYK/RjI74RzHc2wli9TpXOWycQV3YSfpFZ9z+GB/bbsvBon1XMyNf5KXuOwRdHZXIZh1cku3AcIyNroD26MPkbFLHY0+xRI+7u7OsQ6nYcPBpqDiJnB2BMh
;
ns1			IN	A	192.168.1.1
ns2			IN	A	192.168.1.2
;
double			IN	A	192.168.5.1
;
hightype		IN	A	192.168.1.5
hightype		IN	TYPE65534 \# 5 07ED260001
;
localhost		IN	A	127.0.0.1
www			IN	CNAME	outpost.example.com.
;
location		IN	LOC	51 56 0.123 N 5 54 0.000 E 4.00m 1.00m 10000.00m 10.00m
			IN	LOC	51 56 1.456 S 5 54 0.000 E 4.00m 2.00m 10000.00m 10.00m
			IN	LOC	51 56 2.789 N 5 54 0.000 W 4.00m 3.00m 10000.00m 10.00m
			IN	LOC	51 56 3.012 S 5 54 0.000 W 4.00m 4.00m 10000.00m 10.00m
;
unauth			IN	CNAME	no-idea.example.org.
;
dsdelegation		IN	DS	28129 8 1 caf1eaaecdabe7616670788f9022454bf5fd9fda
;
nxd			IN	CNAME	nxdomain.example.com.
;
hwinfo			IN	HINFO	"abc" "def"
;
smtp-servers		IN	A	192.168.0.2
smtp-servers		IN	A	192.168.0.3
smtp-servers		IN	A	192.168.0.4
;
outpost			IN	A	192.168.2.1

start                   IN      CNAME   x.y.z.w1
*.w1                    IN      CNAME   x.y.z.w2
*.w2                    IN      CNAME   x.y.z.w3
*.w3                    IN      CNAME   x.y.z.w4
*.w4                    IN      CNAME   x.y.z.w5
*.w5                    IN      A       1.2.3.5

;
start1			IN	CNAME	start2
start2			IN	CNAME	start3
start3			IN	CNAME	start4
start4			IN	A	192.168.2.2
;
external		IN	CNAME 	somewhere.else.net.
semi-external		IN	CNAME	bla.something.wtest.com.
server1			IN	CNAME	server1.france
; for out-of-bailiwick referral testing
france			IN	NS	ns1.otherprovider.net.
france			IN	NS	ns2.otherprovider.net.
;
; glue record referrals
usa			IN	NS	usa-ns1.usa
usa			IN	NS	usa-ns2.usa
usa-ns1.usa		IN	A	192.168.4.1
usa-ns2.usa		IN	A	192.168.4.2
;
; internal referral
italy			IN	NS	italy-ns1
italy			IN	NS	italy-ns2
italy-ns1		IN	A	192.168.5.1
italy-ns2		IN	A	192.168.5.2
;
mail			IN	MX	25	smtp1
smtp1			IN	CNAME	outpost
;
external-mail		IN	MX	25	server1.test.com.
;
text			IN	TXT	(  
 "Hi, this is some text"   
 )
multitext			IN	TXT	"text part one" "text part two" "text part three"
escapedtext			IN	TXT	"begin" "the \"middle\" p\\art" "the end"
text0			IN	TXT	"k=rsa; p=one"
text1			IN	TXT	"k=rsa\; p=one"
text2			IN	TXT	"k=rsa\\; p=one"
text3			IN	TXT	"k=rsa\\\; p=one"
;
host.*.sub		IN	A	192.168.6.1
;
ipv6			IN	AAAA	2001:6A8:0:1:210:4BFF:FE4B:4C61
;
together-too-much	IN	MX	25	toomuchinfo-a
together-too-much	IN	MX	25	toomuchinfo-b
;
toomuchinfo-a		IN	A	192.168.99.1
toomuchinfo-a		IN	A	192.168.99.2
toomuchinfo-a		IN	A	192.168.99.3
toomuchinfo-a		IN	A	192.168.99.4
toomuchinfo-a		IN	A	192.168.99.5
toomuchinfo-a		IN	A	192.168.99.6
toomuchinfo-a		IN	A	192.168.99.7
toomuchinfo-a		IN	A	192.168.99.8
toomuchinfo-a		IN	A	192.168.99.9
toomuchinfo-a		IN	A	192.168.99.10
toomuchinfo-a		IN	A	192.168.99.11
toomuchinfo-a		IN	A	192.168.99.12
toomuchinfo-a		IN	A	192.168.99.13
toomuchinfo-a		IN	A	192.168.99.14
toomuchinfo-a		IN	A	192.168.99.15
toomuchinfo-a		IN	A	192.168.99.16
toomuchinfo-a		IN	A	192.168.99.17
toomuchinfo-a		IN	A	192.168.99.18
toomuchinfo-a		IN	A	192.168.99.19
toomuchinfo-a		IN	A	192.168.99.20
toomuchinfo-a		IN	A	192.168.99.21
toomuchinfo-a		IN	A	192.168.99.22
toomuchinfo-a		IN	A	192.168.99.23
toomuchinfo-a		IN	A	192.168.99.24
toomuchinfo-a		IN	A	192.168.99.25

toomuchinfo-b		IN	A	192.168.99.26
toomuchinfo-b		IN	A	192.168.99.27
toomuchinfo-b		IN	A	192.168.99.28
toomuchinfo-b		IN	A	192.168.99.29
toomuchinfo-b		IN	A	192.168.99.30
toomuchinfo-b		IN	A	192.168.99.31
toomuchinfo-b		IN	A	192.168.99.32
toomuchinfo-b		IN	A	192.168.99.33
toomuchinfo-b		IN	A	192.168.99.34
toomuchinfo-b		IN	A	192.168.99.35
toomuchinfo-b		IN	A	192.168.99.36
toomuchinfo-b		IN	A	192.168.99.37
toomuchinfo-b		IN	A	192.168.99.38
toomuchinfo-b		IN	A	192.168.99.39
toomuchinfo-b		IN	A	192.168.99.40
toomuchinfo-b		IN	A	192.168.99.41
toomuchinfo-b		IN	A	192.168.99.42
toomuchinfo-b		IN	A	192.168.99.43
toomuchinfo-b		IN	A	192.168.99.44
toomuchinfo-b		IN	A	192.168.99.45
toomuchinfo-b		IN	A	192.168.99.46
toomuchinfo-b		IN	A	192.168.99.47
toomuchinfo-b		IN	A	192.168.99.48
toomuchinfo-b		IN	A	192.168.99.49
toomuchinfo-b		IN	A	192.168.99.50
toomuchinfo-b		IN	A	192.168.99.66
toomuchinfo-b		IN	A	192.168.99.67
toomuchinfo-b		IN	A	192.168.99.68
toomuchinfo-b		IN	A	192.168.99.69
toomuchinfo-b		IN	A	192.168.99.70
toomuchinfo-b		IN	A	192.168.99.71
toomuchinfo-b		IN	A	192.168.99.72
toomuchinfo-b		IN	A	192.168.99.73
toomuchinfo-b		IN	A	192.168.99.74
toomuchinfo-b		IN	A	192.168.99.75
toomuchinfo-b		IN	A	192.168.99.76
toomuchinfo-b		IN	A	192.168.99.77
toomuchinfo-b		IN	A	192.168.99.78
toomuchinfo-b		IN	A	192.168.99.79
toomuchinfo-b		IN	A	192.168.99.80
toomuchinfo-b		IN	A	192.168.99.81
toomuchinfo-b		IN	A	192.168.99.82
toomuchinfo-b		IN	A	192.168.99.83
toomuchinfo-b		IN	A	192.168.99.84
toomuchinfo-b		IN	A	192.168.99.85
toomuchinfo-b		IN	A	192.168.99.86
toomuchinfo-b		IN	A	192.168.99.87
toomuchinfo-b		IN	A	192.168.99.88
toomuchinfo-b		IN	A	192.168.99.89
toomuchinfo-b		IN	A	192.168.99.90



host-0	IN	A	192.168.1.0
host-1	IN	A	192.168.1.1
host-2	IN	A	192.168.1.2
host-3	IN	A	192.168.1.3
host-4	IN	A	192.168.1.4
host-5	IN	A	192.168.1.5
host-6	IN	A	192.168.1.6
host-7	IN	A	192.168.1.7
host-8	IN	A	192.168.1.8
host-9	IN	A	192.168.1.9
host-10	IN	A	192.168.1.10
host-11	IN	A	192.168.1.11
host-12	IN	A	192.168.1.12
host-13	IN	A	192.168.1.13
host-14	IN	A	192.168.1.14
host-15	IN	A	192.168.1.15
host-16	IN	A	192.168.1.16
host-17	IN	A	192.168.1.17
host-18	IN	A	192.168.1.18
host-19	IN	A	192.168.1.19
host-20	IN	A	192.168.1.20
host-21	IN	A	192.168.1.21
host-22	IN	A	192.168.1.22
host-23	IN	A	192.168.1.23
host-24	IN	A	192.168.1.24
host-25	IN	A	192.168.1.25
host-26	IN	A	192.168.1.26
host-27	IN	A	192.168.1.27
host-28	IN	A	192.168.1.28
host-29	IN	A	192.168.1.29
host-30	IN	A	192.168.1.30
host-31	IN	A	192.168.1.31
host-32	IN	A	192.168.1.32
host-33	IN	A	192.168.1.33
host-34	IN	A	192.168.1.34
host-35	IN	A	192.168.1.35
host-36	IN	A	192.168.1.36
host-37	IN	A	192.168.1.37
host-38	IN	A	192.168.1.38
host-39	IN	A	192.168.1.39
host-40	IN	A	192.168.1.40
host-41	IN	A	192.168.1.41
host-42	IN	A	192.168.1.42
host-43	IN	A	192.168.1.43
host-44	IN	A	192.168.1.44
host-45	IN	A	192.168.1.45
host-46	IN	A	192.168.1.46
host-47	IN	A	192.168.1.47
host-48	IN	A	192.168.1.48
host-49	IN	A	192.168.1.49
host-50	IN	A	192.168.1.50
host-51	IN	A	192.168.1.51
host-52	IN	A	192.168.1.52
host-53	IN	A	192.168.1.53
host-54	IN	A	192.168.1.54
host-55	IN	A	192.168.1.55
host-56	IN	A	192.168.1.56
host-57	IN	A	192.168.1.57
host-58	IN	A	192.168.1.58
host-59	IN	A	192.168.1.59
host-60	IN	A	192.168.1.60
host-61	IN	A	192.168.1.61
host-62	IN	A	192.168.1.62
host-63	IN	A	192.168.1.63
host-64	IN	A	192.168.1.64
host-65	IN	A	192.168.1.65
host-66	IN	A	192.168.1.66
host-67	IN	A	192.168.1.67
host-68	IN	A	192.168.1.68
host-69	IN	A	192.168.1.69
host-70	IN	A	192.168.1.70
host-71	IN	A	192.168.1.71
host-72	IN	A	192.168.1.72
host-73	IN	A	192.168.1.73
host-74	IN	A	192.168.1.74
host-75	IN	A	192.168.1.75
host-76	IN	A	192.168.1.76
host-77	IN	A	192.168.1.77
host-78	IN	A	192.168.1.78
host-79	IN	A	192.168.1.79
host-80	IN	A	192.168.1.80
host-81	IN	A	192.168.1.81
host-82	IN	A	192.168.1.82
host-83	IN	A	192.168.1.83
host-84	IN	A	192.168.1.84
host-85	IN	A	192.168.1.85
host-86	IN	A	192.168.1.86
host-87	IN	A	192.168.1.87
host-88	IN	A	192.168.1.88
host-89	IN	A	192.168.1.89
host-90	IN	A	192.168.1.90
host-91	IN	A	192.168.1.91
host-92	IN	A	192.168.1.92
host-93	IN	A	192.168.1.93
host-94	IN	A	192.168.1.94
host-95	IN	A	192.168.1.95
host-96	IN	A	192.168.1.96
host-97	IN	A	192.168.1.97
host-98	IN	A	192.168.1.98
host-99	IN	A	192.168.1.99
;
double			IN	A	192.168.5.1

host-0          IN   EUI48      00-50-56-9b-00-e7
host-1          IN   EUI64      00-50-56-9b-00-e7-7e-57
;
rhs-at-expansion	IN   CNAME      @
