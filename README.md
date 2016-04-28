# powerdns-to-gdnsd
Imports all domains/zones from PowerDNS and generates gdnsd zonefiles

# Testing generated templates: gdnsd -fDSs -c /etc/gdnsd start

# powerdns-to-gdnsd [![Build Status](https://travis-ci.org/extremeshok/powerdns-to-gdnsd.svg?branch=master)](https://travis-ci.org/extremeshok/powerdns-to-gdnsd) [![GitHub Release](https://img.shields.io/github/release/extremeshok/powerdns-to-gdnsd.svg?label=Latest)](https://github.com/extremeshok/powerdns-to-gdnsd/releases/latest)

[![Code Climate](https://codeclimate.com/github/extremeshok/powerdns-to-gdnsd/badges/gpa.svg)](https://codeclimate.com/github/extremeshok/powerdns-to-gdnsd)
[![Test Coverage](https://codeclimate.com/github/extremeshok/powerdns-to-gdnsd/badges/coverage.svg)](https://codeclimate.com/github/extremeshok/powerdns-to-gdnsd/coverage)
[![Issue Count](https://codeclimate.com/github/extremeshok/powerdns-to-gdnsd/badges/issue_count.svg)](https://codeclimate.com/github/extremeshok/powerdns-to-gdnsd)

PowerDNS to gdnsd domain/zone Migrator

## Maintained and provided by https://eXtremeSHOK.com

## Description
The powerdns-to-gdnsd script provides a simple way to export all your domains/zones from PowerDNS into gdnsd. The script will test and generate correct gdnsd zonefiles. The zonefiles can be used directly with gdnsd without needing any changes. There are various tests to ensure the generated zonefiles are valid and minor issues will be fixes automatically. The script will attempt to load the powerdns configs to automatically configure itself to be able to fetch the domain/zone records from the database.

## Assumptions
PowerDNS server (pdns-server) using backend mysql (dns-backend-mysql) with standard table structures (table names and columns)
If the need arises we can add support for other backends/database systems (pgsql, etc)

#### Try our other custom scripts: https://github.com/extremeshok

### Support / Suggestions / Comments
Please post them on the issue tracker : https://github.com/extremeshok/powerdns-to-gdnsd/issues

### Submit Patches / Pull requests to the "master" Branch

### Quick Install Guide
* Download the script
* Set 755 permissions on the script
* Run the the script

### First Usage
* Run the script as your superuser, MySQL settings are automatically detected from the powerdns configs

### Advanced Config Overrides
* Default configs are loaded in the following order if they exist:
* /etc/pdns/pdns.conf -> /etc/pdns/conf.d/gmysql.conf
* A minimum of 1 config is required.
* Specifying a config on the command line (-c | --config) will override the loading of the default configs

#### Check if signature are being loaded
**Run the following command to display any errors with the generated zonefiles
* assumes the generated zonefiles have been copied to /etc/gdnsd/zones
```gdnsd -fDSs -c /etc/gdnsd checkconf```

## Change Log

### Version 2.0.0
 - eXtremeSHOK.com Maintenance
 - Added travis-ci.org code testing

## USAGE

Usage: powerdns-to-gdnsd.sh [OPTION] [PATH|FILE]

