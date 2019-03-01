#!/bin/bash
################################################################################
# This is property of eXtremeSHOK.com
# You are free to use, modify and distribute, however you may not remove this notice.
# Copyright (c) Adrian Jon Kriel :: admin@extremeshok.com
################################################################################
#
# Script updates can be found at: https://github.com/extremeshok/powerdns-to-gdnsd
#
# License: BSD (Berkeley Software Distribution)
#
################################################################################
#
# Dependencies: mysql-client
#
# Assumptions: powerdns using mysql with standard table structures (table names and columns)
#
# Note: MySQL values are automatically detected from the powerdns configs
#
# Testing generated templates: gdnsd -fDSs -c /etc/gdnsd start
#
################################################################################
#
#    THERE ARE  USER CONFIGURABLE OPTIONS IN THIS SCRIPT
#   ALL CONFIGURATION OPTIONS ARE LOCATED BELOW THIS MESSAGE
#
################################################################################

#### User Config ################################

# Default powerdns mysql table names
domains_table="domains"
records_table="records"

# Location of export directory
output_dir="export"

# Force a custom SOA Hostmaster for all the domains
#force_soa_hostmaster="admin.extremeshok.com"

# Force a custom SOA nameserver1 for all the domains
#force_soa_ns1="xs1.extremeshok.com"


# Custom serial for soa : 1yyyymmdd01
default_soa_serial="1$(date -u +%Y%m%d0)"
# EPOCH serial for soa : 1461802858
#default_soa_serial=$(date -u +%s)

# Force the default_soa_serial to be used
force_default_soa_serial="NO" #set to YES to enable

# Foce specific ttl values, uncomment to enable
#force_record_ttl="3600" #1 hour
force_ns_ttl="84600" #1 day
force_mx_ttl="14400" #4 hours
default_ttl="3600"

# Due to gdnsd not supporting dnssec, we will disable dnssec record types
# Disabled record types are specified in the dnssec_record_types array
disable_dnssec_records="YES" #set to NO to disable

# Due to gdnsd not supporting obselete and some non-standard record types, we will disable them
# Disabled record types are specified in the not_implemented_record_types array
disable_not_implemented_records="YES" #set to NO to disable

# Records that need to be disabled due to dnssec or not implemented
# According to: https://github.com/gdnsd/gdnsd/blob/master/t/Net/DNS.pm
dnssec_record_types=("SIG" "KEY" "NXT" "DS" "RRSIG" "NSEC" "DNSKEY" "DLV")
not_implemented_record_types=("MD" "MF" "WKS" "NSAP_PTR" "GPOS" "ATMA" "A6" "SINK" "NINFO" "RKEY" "TA" "LOC" "HINFO" "EUI64" "EUI48" "TYPE65534")

# Shortens the record names by removing the domain name from them
# This enhances the readability of your templates
# eg. www.domain.com. --> www
# eg. domain.com. --> @
shorten_domain_records="YES" #set to NO to disable

# Add missing ending dots to records, this is dependent on your PowerDNS
# the script will attempt to validate if the record requires a dot
# ie. that it is a FQDN and the record accepts a trailing dot
add_dots_to_records="YES"

# Add the missing ns record for the domain's soa ns 1 if it is not found in the NS records
# Sometimes the domain will be missing the ns record of the soa ns1, this will fix this
add_mssing_ns_record_for_domain_soa_ns1="YES"

#### End of User Config #########################

################################################################################

######  #######    #     # ####### #######    ####### ######  ### #######
#     # #     #    ##    # #     #    #       #       #     #  #     #
#     # #     #    # #   # #     #    #       #       #     #  #     #
#     # #     #    #  #  # #     #    #       #####   #     #  #     #
#     # #     #    #   # # #     #    #       #       #     #  #     #
#     # #     #    #    ## #     #    #       #       #     #  #     #
######  #######    #     # #######    #       ####### ######  ###    #

################################################################################

# Detect to make sure the entire script is avilable, fail if the script is missing contents
if [ ! "$( tail -1 "$0" | head -1 | cut -c1-7 )" == "exit \$?" ] ; then
  echo "FATAL ERROR: Script is incomplete, please redownload"
  exit 1
fi

################################################################################
# HELPER FUNCTIONS
################################################################################

# Function to check if its a file, otherwise return false
function xshok_is_file () { #"filepath"
  filepath=$1
  if [ -f "${filepath}" ]; then
    return 0 ;
  else
    return 1 ;	#not a file
  fi
}

# Function to handle comments with/out borders.
# Usage:
# pretty_echo_and_log "one"
# one
# pretty_echo_and_log "two" "-"
# ---
# two
# ---
# pretty_echo_and_log "three" "=" "8"
# ========
# three
# ========
# pretty_echo_and_log "" "/\" "7"
# /\/\/\/\/\/\
#type: e = error, w= warning ""
function xshok_pretty_echo () { #"string" "repeating" "count" "type"
  # handle comments
  if [ "$comment_silence" = "no" ] ; then
    if [ "${#@}" = "1" ] ; then
      echo "$1"
    else
      myvar=""
      if [ -n "$3" ] ; then
        mycount="$3"
      else
        mycount="${#1}"
      fi
      for (( n = 0; n < mycount; n++ )) ; do
        myvar="$myvar$2"
      done
      if [ "$1" != "" ] ; then
        echo -e "$myvar\n$1\n$myvar"
      else
        echo -e "$myvar"
      fi
    fi
  fi
}

# Function to check if the $2 value is not null and does not start with -
function xshok_check_s2 () {
  if [ "$1" ]; then
    if [[ "$1" =~ ^-.* ]]; then
      xshok_pretty_echo "ERROR: Missing value for option or value begins with -" "="
      exit 1
    fi
  else
    xshok_pretty_echo "ERROR: Missing value for option" "="
    exit 1
  fi
}

# Function mysqlread prevents collapsing of empty fields when reading a mysql result
function xshok_mysql_read () {
  local input
  IFS= read -r input || return $?
  while (( $# > 1 )); do
    IFS= read -r "$1" <<< "${input%%[$IFS]*}"
    input="${input#*[$IFS]}"
    shift
  done
  IFS= read -r "$1" <<< "$input"
}

# Function to determin if an array contains a specific string
function xshok_is_in_array () { #arrayname #string
  local haystack=${1}[@]
  local needle=${2}
  for i in ${!haystack}; do
    if [[ "${i}" == "${needle}" ]]; then
      return 0
    fi
  done
  return 1
}


################################################################################
# ADDITIONAL PROGRAM FUNCTIONS
################################################################################

function help_and_usage () {
  #option_format_start
  ofs="${BOLD}"
  #option_format_end
  ofe="${NORM}\t"
  #option_format_blankline
  ofb="\n"
  #option_format_tab_line
  oft="\n\t"

  helpcontents=$(cat << EOF
$ofb
$ofs Usage: $(basename "$0") $ofe [OPTION] [PATH|FILE]
$ofb
$ofs -h, --help $ofe Display this script's help and usage information
$ofb
$ofs -V, --version $ofe Output script version and date information
$ofb
$ofs -v, --verbose $ofe Be verbose, enabled when not run under cron
$ofb
$ofs -s, --silence $ofe Only output error messages, enabled when run under cron
$ofb
$ofs -o, --output $ofe Output the zonefiles to a specific directory eg: '-o /your/directory'
$ofb
$ofs -c, --config $ofe Use a specific configuration file $oft eg: '-c /your/file.name'
$ofb
EOF
  ) #this is very important...

  echo -e "$helpcontents"
}


# Function to check for a new version
function check_new_version () {
  latest_version=$($curl_bin https://raw.githubusercontent.com/extremeshok/powerdns-to-gdnsd/master/clamav-unofficial-sigs.sh 2> /dev/null | grep  "script""_version=" | cut -d\" -f2)
  if [ "$latest_version" ] ; then
    if [ ! "$latest_version" == "$script_version" ] ; then
      xshok_pretty_echo "New version : v$latest_version @ https://github.com/extremeshok/powerdns-to-gdnsd" "-"
    fi
  fi
}

################################################################################
# MAIN PROGRAM
################################################################################

# Script Info
script_version="2.1.0"
script_version_date="29 April 2016"

# Generic command line options
while true ; do
  case "$1" in
    -v | --verbose ) force_verbose="yes"; shift 1; break ;;
    -s | --silence ) force_verbose="no"; shift 1; break ;;
    * ) break ;;
  esac
done

#Detect if terminal
if [ -t 1 ] ; then
  #Set fonts
  ##Usage: echo "${BOLD}-a${NORM}"
  BOLD=$(tput bold)
  REV=$(tput smso)
  NORM=$(tput sgr0)
  #Verbose
  force_verbose="yes"
else
  #Null Fonts
  BOLD=''
  REV=''
  NORM=''
  #silence
  force_verbose="no"
fi

#Set the verbosity
if [ "$force_verbose" == "yes" ] ; then
  #verbose
  comment_silence="no"
else
  #silence
  comment_silence="yes"
fi

xshok_pretty_echo "" "#" "80"
xshok_pretty_echo " eXtremeSHOK.com PowerDNS MySQL to gdnsd converter"
xshok_pretty_echo " Version: v$script_version ($script_version_date)"
xshok_pretty_echo " Copyright (c) Adrian Jon Kriel :: admin@extremeshok.com"
xshok_pretty_echo "" "#" "80"

# System checking
curl_bin=$(which curl)
if [ "$curl_bin" == "" ] ; then
  xshok_pretty_echo "ERROR: curl binary (curl_bin) not found" "="
  exit 1
fi
mysql_bin=$(which mysql)
if [ "$mysql_bin" == "" ] ; then
  xshok_pretty_echo "ERROR: mysql binary (mysql_bin) not found" "="
  exit 1
fi

custom_config="no"
# Generic command line options
while true ; do
  case "$1" in
    -h | --help ) help_and_usage; exit; break ;;
    -V | --version ) exit; break ;;
    -c | --config ) xshok_check_s2 "$2"; custom_config="$2"; shift 2; break ;;
    -o | --output ) xshok_check_s2 "$2"; output_dir="$2"; shift 2; break ;;
    * ) break ;;
  esac
done

# Config loading
powerdns_db_name=""
powerdns_db_user=""
powerdns_db_pass=""
powerdns_db_host=""
powerdns_db_port=""

#default config files
config_files=("/etc/powerdns/pdns.conf" "/etc/powerdns/pdns.d/pdns.local.conf" "/etc/powerdns/pdns.d/pdns.local.gmysql.conf" "/etc/pdns/pdns.conf" "/etc/pdns/conf.d/gmysql.conf")
## CONFIG LOADING AND ERROR CHECKING ##############################################
if [ "$custom_config" != "no" ] ; then
  if [ ! -r "$custom_config" ]; then
    xshok_pretty_echo "ERROR: custom config not found / readable : $custom_config" "="
    exit 1
  else
    config_files=("$custom_config")
  fi
fi

we_have_a_config="0"
for config_file in "${config_files[@]}" ; do
  if [ -r "$config_file" ] ; then #exists and readable

    #config stripping

    # Load the powerdns config values
    if [ ! -z "$(grep 'gmysql-user' "$config_file" | grep -v '#')" ] ; then
      xshok_pretty_echo "Loading config: $config_file" "="
      #found mysql values, process file
      powerdns_db_name=$(grep 'gmysql-dbname' "$config_file" | cut -f'2' -d'=' | tr -s ' ')
      powerdns_db_user=$(grep 'gmysql-user' "$config_file" | cut -f'2' -d'=' | tr -s ' ')
      powerdns_db_pass=$(grep 'gmysql-password' "$config_file" | cut -f'2' -d'=' | tr -s ' ')
      powerdns_db_host=$(grep 'gmysql-host' "$config_file" | cut -f'2' -d'=' | tr -s ' ')
      powerdns_db_port=$(grep 'gmysql-port' "$config_file" | cut -f'2' -d'=' | tr -s ' ')
    fi

    if [ "$powerdns_db_name" != "" ] && [ "$powerdns_db_user" != "" ] ; then
      we_have_a_config="1"
      break  # Skip entire rest of loop.
    fi

  fi
done

## Make sure we have a readable config file
if [ "$we_have_a_config" == "0" ] ; then
  xshok_pretty_echo "ERROR: Config file/s could NOT be read/loaded" "="
  exit 1
fi

######
if [ "$powerdns_db_host" != "" ] ; then
  powerdns_db_host="127.0.0.1"
fi
if [ "$powerdns_db_port" != "" ] ; then
  powerdns_db_port="3306"
fi

# Set mysql password if there is a password set
if [ "$powerdns_db_pass" != "" ] ; then
  MYSQLCMD="$mysql_bin --skip-column-names --host=$powerdns_db_host --port=$powerdns_db_port --user=$powerdns_db_user --password=$powerdns_db_pass $powerdns_db_name --silent"
else
  MYSQLCMD="$mysql_bin --skip-column-names --host=$powerdns_db_host --port=$powerdns_db_port --user=$powerdns_db_user $powerdns_db_name --silent"
fi

# Create the output_dir and remove trailing / (removes / and //)
output_dir=$(echo "$output_dir" | sed 's:/*$::')
mkdir -p "$output_dir"
if [ ! -w "$output_dir" ] ; then
  echo "ERROR: Output dir is not writable: $output_dir"
  exit 1
fi

# Get domains
while read -r domain_id domain_name domain_master domain_type domain_notified_serial; do

  xshok_pretty_echo "$domain_name - ID: $domain_id - SOA: $domain_notified_serial"

  ## GENERATE SOA, we only read 1 record, as there should only be a single SOA
  domain_soa="$($MYSQLCMD -e "SELECT content FROM $records_table WHERE type = 'SOA' AND domain_id = '$domain_id' AND disabled = '0' ORDER BY name LIMIT 1;")"
  read -r domain_soa_ns1 domain_soa_hostmaster domain_soa_serial domain_soa_refresh domain_soa_retry domain_soa_expire domain_soa_ncache < <(echo "$domain_soa" | tr ':' ' ');

  if [ -n "$force_soa_hostmaster" ] ; then
    domain_soa_hostmaster="$force_soa_hostmaster"
  fi
  # Enforce correct hostmaster format (remove +, remove @, add trailing .)
  domain_soa_hostmaster=${domain_soa_hostmaster/+/.}
  domain_soa_hostmaster=${domain_soa_hostmaster/@/.}
  if [ "${domain_soa_hostmaster: -1}" != "." ] ; then
    domain_soa_hostmaster="$domain_soa_hostmaster."
  fi

  if [ -n "$force_default_soa_serial" ] ; then
    domain_soa_serial="$default_soa_serial"
  elif [[ "$domain_notified_serial" -ne "0" ]] ; then
    domain_soa_serial="$domain_notified_serial"
  else
    domain_soa_serial="$default_soa_serial"
  fi

  if [ -n "$force_soa_ns1" ] ; then
    domain_soa_ns1="$force_soa_ns1"
  fi
  if [ "${domain_soa_ns1: -1}" != "." ] ; then
    domain_soa_ns1="$domain_soa_ns1."
  fi

  # Fix invalid soa_ncache
  if [ "$domain_soa_ncache" -gt "10800" ] ; then
    domain_soa_ncache="900"
  fi



  cat << EOF > "$output_dir/$domain_name"
; eXtremeSHOK.com PowerDNS to gdnsd migration script
; Copyright (c) Adrian Jon Kriel :: admin@extremeshok.com

\$TTL $default_ttl
\$ORIGIN $domain_name.
@  1D  IN SOA  $domain_soa_ns1  $domain_soa_hostmaster  (
  $domain_soa_serial  ; serial
  $domain_soa_refresh  ; refresh
  $domain_soa_retry  ; retry
  $domain_soa_expire  ; expire
  $domain_soa_ncache  ; ncache
  )
EOF

  # ALL RECORDS
  # Initialise for new domain
  previous_record_type=""
  ns_record_ttl=""

  if [ "$add_mssing_ns_record_for_domain_soa_ns1" != "YES" ] ; then
    domain_soa_ns1_found_in_ns="YES"
  else
    domain_soa_ns1_found_in_ns="NO"
  fi

  # Loop though the result rows
  while IFS=$'\t' xshok_mysql_read record_name record_type record_content record_ttl record_prio record_change_date record_ordername; do
    # Assign to varibles without needing the {} and remove trailing whitespace
    record_name="$(echo "${record_name}" | xargs)"
    record_type="$(echo "${record_type}" | xargs)"
    record_content="$(echo "${record_content}")"
    record_ttl="$(echo "${record_ttl}" | xargs)"
    record_prio="$(echo "${record_prio}" | xargs)"
    record_change_date="$(echo "${record_change_date}" | xargs)"
    record_ordername="$(echo "${record_ordername}" | xargs)"

    # Record types should be uppercase
    record_type="${record_type^^}"

    # Add the trailing . (attemtping to detect when it is required)
    if [ "$add_dots_to_records" == "YES" ] ; then

      ## RECORD_NAME
      # Check if last character is not a .
      if [ "${record_name: -1}" != "." ] ; then
        #support for *. domain records (*.xyz.com and abc.*.xyz.com)
        if [[ "$record_name" == *"*."* ]] ; then
          temp_record_name="${record_name/\*./}"
        else
          temp_record_name="$record_name"
        fi
        # Check the record_name is a domain
        if [[ ! -z "$(echo "$temp_record_name" | grep -P '(?=^.{1,254}$)(^(?>(?!\d+\.)[a-zA-Z0-9_\-]{1,63}\.?)+(?:[a-zA-Z]{2,})$)')" ]] ; then
          record_name="$record_name."
        fi
      fi

      ## RECORD_CONTENT
      #this will add . to the end of any FQDN inside string
      #this code block was tested with the following string
      #record_content="\"u\" \"e2u+sip\" *.yes www.*.domain.com \"\" testuser.domain.com"
      read -ra record_content_array <<<"$record_content"
      i=0; for record_content_array_element in "${record_content_array[@]}"; do
        # Check if last character is not a .
        if [ "${record_content_array_element: -1}" != "." ] ; then
          #support for *. domain records (*.xyz.com and abc.*.xyz.com)
          if [[ "$record_content_array_element" == *"*."* ]] ; then
            temp_record_content_array_element="${record_content_array_element/\*./}"
          else
            temp_record_content_array_element="$record_content_array_element"
          fi
          # Check the record_name is a domain
          if [[ ! -z "$(echo "$temp_record_content_array_element" | grep -P '(?=^.{1,254}$)(^(?>(?!\d+\.)[a-zA-Z0-9_\-]{1,63}\.?)+(?:[a-zA-Z]{2,})$)')" ]] ; then
            #reassign the new value to the current array element
            record_content_array[$i]="$record_content_array_element."
          fi
        fi
        let i++;
      done
      #reassign the array into a string
      record_content="${record_content_array[*]}"
    fi

    if [ "$previous_record_type" == "" ] || [ "$previous_record_type" != "$record_type" ] ; then
      previous_record_type="$record_type"

      case "$record_type" in
        "A")
          record_type_message="; Address records"
          ;;
        "AAAA")
          record_type_message="; IPv6 Address records"
          ;;
        "CNAME")
          record_type_message="; Canonical name records"
          ;;
        "DNAME")
          record_type_message="; Delegation name records"
          ;;
        "URI")
          record_type_message="; Uniform Resource Identifiers"
          ;;
        "TXT")
          record_type_message="; Text records : DKIM/DMARC/SPF/DNS-SD/etc."
          ;;
        "MX")
          record_type_message="; Mail exchangers"
          ;;
        "NS")
          record_type_message="; Name server records"
          ;;
        "SRV")
          record_type_message="; Service locators"
          ;;
        *)
          record_type_message="; $record_type"
          ;;
      esac

      echo -e "\n$record_type_message\n" >> "$output_dir/$domain_name"

    fi

    if [ "$record_type" == "NS" ] ; then
      # Check the SOA NS is present in the template, we will add the record if its not
      if [ "$domain_soa_ns1_found_in_ns" != "YES" ] ; then
        if [ "$record_content" == "$domain_soa_ns1" ]; then
          domain_soa_ns1_found_in_ns="YES"
        fi
      fi
      # All TTLs for type NS should match
      if [ "$ns_record_ttl" == "" ] ; then
        ns_record_ttl="$record_ttl"
      else
        record_ttl="$ns_record_ttl"
      fi
    fi

    # CNAME not allowed alongside other data at domainname 'domain.com.'
    # ie. disable cname record that is the domain name.
    if [ "$record_type" == "CNAME" ] ; then
      tmp_record_name=$(echo "$record_name" | sed 's:\.*$::')
      if [ "$tmp_record_name" == "$domain_name" ]; then
        xshok_pretty_echo "-- Disabled Record: cname record is the domain name"
        record_name="; $record_name"
      fi
    fi

    # Disable invalid record that begins with @.
    if [[ ${record_name:0:2} == "@." ]]  ; then
      xshok_pretty_echo "-- Disabled Record: begins with @."
      record_name="; $record_name"
    fi

    # Disable not implemented record types
    if [ "$disable_not_implemented_records" == "YES" ] ; then
      if xshok_is_in_array not_implemented_record_types "$record_type" ; then
        xshok_pretty_echo "-- Disabled Record: not implemented record type"
        record_name="; $record_name"
      fi
    fi

    # Disable dnssec record types
    if [ "$disable_dnssec_records" == "YES" ] ; then
      if xshok_is_in_array dnssec_record_types "$record_type" ; then
        xshok_pretty_echo "-- Disabled Record: dnssec record type"
        record_name="; $record_name"
      fi
    fi


    if [ "$shorten_domain_records" == "YES" ] ; then
      # Remove trailing . (removes . and ..)
      tmp_record_name=$(echo "$record_name" | sed 's:\.*$::')
      if [ "$tmp_record_name" == "$domain_name" ]; then
        record_name="@"
      else
        record_name="${record_name%.$domain_name.}" #remove domain name from the end
      fi
    fi

    if [ -n "$force_record_ttl" ] && [ "$record_type" != "NS" ]  ; then
      record_ttl="$force_record_ttl"
    fi

    if [ "$record_ttl" == "0" ] ; then
      record_ttl=""
    fi

    if ( [ "$record_prio" == "0" ] && [ "$record_type" != "MX" ] && [ "$record_type" != "SRV" ] ) || [ "$record_type" == "NS" ]; then
      record_prio=""
    fi

    if [ "$record_type" == "MX" ] && [ -n "$force_mx_ttl" ] ; then
      record_ttl="$force_mx_ttl"
    elif [ "$record_type" == "NS" ] && [ -n "$force_ns_ttl" ] ; then
      record_ttl="$force_ns_ttl"
    elif [ -n "$force_record_ttl" ] ; then
      record_ttl="$force_record_ttl"
    fi

    if [ "$record_type" == "TXT" ] ; then
      if [ "${record_content: -1}" != "\"" ] ; then
        # add " to the end
        record_content="$record_content\""
      fi
      if [ "${record_content:0:1}" != "\"" ] ; then
        # add " to the beginning
        record_content="\"$record_content"
      fi
    fi

    # Bug fix: replace all \\ with \
    record_content="${record_content//\\\\/\\}"

    echo "$record_name  $record_ttl  IN  $record_type  $record_prio  $record_content" >> "$output_dir/$domain_name"

    #End records
  done < <($MYSQLCMD --batch -e "SELECT name, type,  content, ttl, prio, change_date, ordername FROM $records_table WHERE domain_id = '$domain_id' AND disabled = '0' AND type != 'SOA' ORDER BY type;")


  # No ns_record_ttl was defined, this means we have no NS records and the domain is invalid.
  if [ "$ns_record_ttl" == "" ] ; then
    rm -f "$output_dir/$domain_name"
    xshok_pretty_echo "-- Invalid: $domain_name has no NS records and was removed"
  else
    if [ "$domain_soa_ns1_found_in_ns" != "YES" ] ; then
      xshok_pretty_echo "-- Added: missing NS record for $domain_name"
      echo "@  $ns_record_ttl  NS    $domain_soa_ns1" >> "$output_dir/$domain_name"
    fi
    # Last line of zonefile is always blank
    echo "" >> "$output_dir/$domain_name"
  fi

  # End domains
done < <($MYSQLCMD -NB -e "SELECT id, name, master, type, notified_serial FROM $domains_table ORDER BY name;")


xshok_pretty_echo "Issue tracker : https://github.com/extremeshok/powerdns-to-gdnsd/issues" "-"

check_new_version

xshok_pretty_echo "      Powered By https://eXtremeSHOK.com      " "#"

# And lastly we exit, Note: the exit is always on the 2nd last line
exit $?
