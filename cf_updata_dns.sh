#!/bin/bash
#
#    cf_update_dns.sh - CloudFlare Update DNS 
#
#    Leon de Jager <ldejager[at]coretanium.net>
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

CF_TOKEN=""
CF_EMAIL=""
CF_OLDIP="$1"
CF_NEWIP="$2"
CF_CSITE="$3"

function Usage() {
    if [ x$1 == "x" ]
      then
        echo "Usage: $0 <oldip> <newip> <domain>"
        exit
    fi
}

function GetDNS() {

    curl -s https://www.cloudflare.com/api_json.html \
      -d "a=rec_load_all" \
      -d "tkn=$CF_TOKEN" \
      -d "email=$CF_EMAIL" \
      -d "z=$CF_CSITE" | python -mjson.tool > cf_data.txt
}

function UpdateDNS() {

    grep -A 3 -E "\"content\"\: \"${CF_OLDIP}\"" -n cf_data.txt | grep -E "\"content\"\:|\"name\"\:" | sed 'N;s/\n/ /' | awk '{ print $1,$6 }' | sed -e 's/\://g' -e 's/\"//g' -e 's/\,//g' | while read RID RNAME
     do

       RECID=$(echo $RID + 16 | bc -q)

       [[ -z "${RECID}" ]] && echo "No records found for ${CF_OLDIP}"

       DNSID=$(sed -n "${RECID} p" cf_data.txt | cut -d ":" -f2 | sed "s/\"//g;s/ //;s/\,//")

       echo "Updating DNS record (${RNAME}) with ID #: ${DNSID}"
       
       curl -s https://www.cloudflare.com/api_json.html \
        -d 'a=rec_edit' \
        -d "tkn=${CF_TOKEN}" \
        -d "id=$DNSID" \
        -d "email=${CF_EMAIL}" \
        -d "z=${CF_CSITE}" \
        -d "type=A" \
        -d "name=${RNAME}" \
        -d "content=${CF_NEWIP}" \
        -d "ttl=1" | grep -q '"result":"success"';
    
        if [ $? -eq 0 ]
          then
           sleep 0;
            echo "Successfully changed DNS records for ${RNAME} to ${CF_NEWIP}"
        else
            echo "Failed to update DNS for ${RNAME} to ${CF_NEWIP}"
        fi

    done
}


[[ $# -lt 3 ]] && Usage

GetDNS
UpdateDNS ${CF_OLDIP}

[ ! -f cf_data.txt ] && echo "cf_data.txt not found..." || rm -f cf_data.txt

exit 0
