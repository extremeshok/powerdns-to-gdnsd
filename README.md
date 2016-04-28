# powerdns-to-gdnsd [![Build Status](https://travis-ci.org/extremeshok/powerdns-to-gdnsd.svg?branch=master)](https://travis-ci.org/extremeshok/powerdns-to-gdnsd) [![GitHub Release](https://img.shields.io/github/release/extremeshok/powerdns-to-gdnsd.svg?label=Latest)](https://github.com/extremeshok/powerdns-to-gdnsd/releases/latest)

[![Code Climate](https://codeclimate.com/github/extremeshok/powerdns-to-gdnsd/badges/gpa.svg)](https://codeclimate.com/github/extremeshok/powerdns-to-gdnsd)
[![Test Coverage](https://codeclimate.com/github/extremeshok/powerdns-to-gdnsd/badges/coverage.svg)](https://codeclimate.com/github/extremeshok/powerdns-to-gdnsd/coverage)
[![Issue Count](https://codeclimate.com/github/extremeshok/powerdns-to-gdnsd/badges/issue_count.svg)](https://codeclimate.com/github/extremeshok/powerdns-to-gdnsd)

PowerDNS to gdnsd domain/zone Migrator

## Maintained and provided by https://eXtremeSHOK.com

## Description
The powerdns-to-gdnsd script provides a simple way to export all your domains/zones from PowerDNS into gdnsd. The script will test and generate correct gdnsd zonefiles. The zonefiles can be used directly with gdnsd without needing any changes. There are various tests to ensure the generated zonefiles are valid and minor issues will be fixes automatically. The script will attempt to load the powerdns configs to automatically configure itself to be able to fetch the domain/zone records from the database. Due to gdnsd not supporting dnssec as well as some obselete and non-standard record types, they we will be automatically disabled. The script will also disable any invalid records. 

## Assumptions
PowerDNS server (pdns-server) using backend MySQL (dns-backend-mysql / gmysqlbackend) with the standard scheme (table names and columns) : https://raw.githubusercontent.com/PowerDNS/pdns/master/modules/gmysqlbackend/schema.mysql.sql
If the need arises we can add support for other backends/database systems (pgsql, sqlite, etc)

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

### Config Files and Detected Settings
* Default configs are loaded in the following order if they exist:
* /etc/powerdns/pdns.conf -> /etc/powerdns/pdns.d/pdns.local.conf -> /etc/powerdns/pdns.d/pdns.local.gmysql.conf ->  /etc/pdns/pdns.conf -> /etc/pdns/conf.d/gmysql.conf
* A minimum of 1 config is required which contains the database parameters.
* Specifying a config on the command line (-c | --config) will override the loading of the default configs

#### Testing generated zonefiles
* Run the following command to display any errors with the generated zonefiles 
* assumes gdnsd is installed and the generated zonefiles have been copied to /etc/gdnsd/zones

```gdnsd -fDSs -c /etc/gdnsd checkconf```

## Change Log

### Version 2.1.0 ( 29 April 2016 )
 - eXtremeSHOK.com Maintenance
 - Added function xshok_is_in_array to check if a string is in an array
 - Added option to disable dnssec records
 - Added option to disable not implemented records

### Version 2.0.0
 - eXtremeSHOK.com Maintenance
 - Refactored for Public Releas
 - Added travis-ci.org code testing

### Version 1.x.x
 - eXtremeSHOK.com Internal

## USAGE

Usage: powerdns-to-gdnsd.sh [OPTION] [PATH|FILE]

