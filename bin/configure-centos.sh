#!/usr/bin/env bash

#   +---------------------------------------------------------------------------------+
#   | This file is part of greathouse-openresty                                       |
#   +---------------------------------------------------------------------------------+
#   | Copyright (c) 2017 Greathouse Technology LLC (http://www.greathouse.technology) |
#   +---------------------------------------------------------------------------------+
#   | greathouse-openresty is free software: you can redistribute it and/or modify    |
#   | it under the terms of the GNU General Public License as published by            |
#   | the Free Software Foundation, either version 3 of the License, or               |
#   | (at your option) any later version.                                             |
#   |                                                                                 |
#   | greathouse-openresty is distributed in the hope that it will be useful,         |
#   | but WITHOUT ANY WARRANTY; without even the implied warranty of                  |
#   | MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                   |
#   | GNU General Public License for more details.                                    |
#   |                                                                                 |
#   | You should have received a copy of the GNU General Public License               |
#   | along with greathouse-openresty.  If not, see <http://www.gnu.org/licenses/>.   |
#   +---------------------------------------------------------------------------------+
#   | Author: Jesse Greathouse <jesse@greathouse.technology>                          |
#   +---------------------------------------------------------------------------------+

# This script will prompt the user to provide necessary strings
# to customize their run script

# resolve real path to script including symlinks or other hijinks
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  TARGET="$(readlink "$SOURCE")"
  if [[ ${TARGET} == /* ]]; then
    printf "SOURCE '$SOURCE' is an absolute symlink to '$TARGET'"
    SOURCE="$TARGET"
  else
    BIN="$( dirname "$SOURCE" )"
    printf "SOURCE '$SOURCE' is a relative symlink to '$TARGET' (relative to '$BIN')"
    SOURCE="$BIN/$TARGET" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
  fi
done
RBIN="$( dirname "$SOURCE" )"
BIN="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
DIR="$( cd -P "$BIN/../" && pwd )"
ETC="$( cd -P "$DIR/etc" && pwd )"
TMP="$( cd -P "$DIR/tmp" && pwd )"
USER="$(whoami)"
RUN_SCRIPT="${BIN}/run-centos.sh"
SERVICE_RUN_SCRIPT="${BIN}/run-centos-service.sh"
NGINX_CONF="${ETC}/nginx/nginx.conf"

printf "\n"
printf "\n"
printf "+---------------------------------------------------------------------------------+\n"
printf "| Thank you for choosing greathouse-openresty                                     |\n"
printf "+---------------------------------------------------------------------------------+\n"
printf "| Copyright (c) 2017 Greathouse Technology LLC (http://www.greathouse.technology) |\n"
printf "+---------------------------------------------------------------------------------+\n"
printf "| greathouse-openresty is free software: you can redistribute it and/or modify    |\n"
printf "| it under the terms of the GNU General Public License as published by            |\n"
printf "| the Free Software Foundation, either version 3 of the License, or               |\n"
printf "| (at your option) any later version.                                             |\n"
printf "|                                                                                 |\n"
printf "| greathouse-openresty is distributed in the hope that it will be useful,         |\n"
printf "| but WITHOUT ANY WARRANTY; without even the implied warranty of                  |\n"
printf "| MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                   |\n"
printf "| GNU General Public License for more details.                                    |\n"
printf "|                                                                                 |\n"
printf "| You should have received a copy of the GNU General Public License               |\n"
printf "| along with greathouse-openresty.  If not, see <http://www.gnu.org/licenses/>.   |\n"
printf "+---------------------------------------------------------------------------------+\n"
printf "| Author: Jesse Greathouse <jesse@greathouse.technology>                          |\n"
printf "+---------------------------------------------------------------------------------+\n"
printf "\n"
printf "\n"
printf "=================================================================\n"
printf "Hello, "${USER}".  This will create your site's run script\n"
printf "=================================================================\n"
printf "\n"
printf "Enter your name of your site [demotivational]: "
read SITE_NAME
if  [ "${SITE_NAME}" == "" ]; then
    SITE_NAME="demotivational"
fi
printf "Enter the domains of your site [127.0.0.1 localhost]: "
read SITE_DOMAINS
if  [ "${SITE_DOMAINS}" == "" ]; then
    SITE_DOMAINS="127.0.0.1 localhost"
fi
printf "Enter your website port [80]: "
read PORT
if  [ "${PORT}" == "" ]; then
    PORT="80"
fi
printf "Enter your Google Search Engine ID: "
read GOOGLE_SEARCH_ENGINE_ID
if  [ "${GOOGLE_SEARCH_ENGINE_ID}" == "" ]; then
    GOOGLE_SEARCH_ENGINE_ID="013635473867759795943:b9ipomklvyt"
fi
printf "Enter your Google Search API Key: "
read GOOGLE_SEARCH_KEY
if  [ "${GOOGLE_SEARCH_KEY}" == "" ]; then
    GOOGLE_SEARCH_KEY="AIzaSyCCqmz99T_8_6_ZDgkZqoD2ACWG9wmXEdE"
fi
printf "Enter your Google Oauth Key: "
read GOOGLE_OAUTH_KEY
if  [ "${GOOGLE_OAUTH_KEY}" == "" ]; then
    GOOGLE_OAUTH_KEY="248720560989-hre42f9t6is8evgqfhkr3hc8uqq7pg5c.apps.googleusercontent.com"
fi
printf "Enter your Google Oauth Secret : "
read GOOGLE_OAUTH_SECRET
if  [ "${GOOGLE_OAUTH_SECRET}" == "" ]; then
    GOOGLE_OAUTH_SECRET="bQzvTkXmshV666YbaUpUza2H"
fi
printf "Enter your Facebook Oauth Key:"
read FACEBOOK_OAUTH_KEY
if  [ "${FACEBOOK_OAUTH_KEY}" == "" ]; then
    FACEBOOK_OAUTH_KEY="834641043716782"
fi
printf "Enter your Facebook Oauth Secret: "
read FACEBOOK_OAUTH_SECRET
if  [ "${FACEBOOK_OAUTH_SECRET}" == "" ]; then
    FACEBOOK_OAUTH_SECRET="ba83621e274fe848ae2fdac7407cdfdc"
fi
printf "Force visitors to https? (y or n): "
read -n 1 FORCE_SSL
if  [ "${FORCE_SSL}" == "y" ]; then
    FORCE_SSL="true"
else
    FORCE_SSL="false"
fi


printf "\n"
printf "You have entered the following configuration: \n"
printf "\n"
printf "Site Name: ${SITE_NAME} \n"
printf "Site Domains: ${SITE_DOMAINS} \n"
printf "Web Port: ${PORT} \n"
printf "Google Search Engine ID: ${GOOGLE_SEARCH_ENGINE_ID} \n"
printf "Google Search Key: ${GOOGLE_SEARCH_KEY} \n"
printf "Google Oauth Key: ${GOOGLE_OAUTH_KEY} \n"
printf "Google Oauth Secret: ${GOOGLE_OAUTH_SECRET} \n"
printf "Facebook Oauth Key: ${FACEBOOK_OAUTH_KEY} \n"
printf "Facebook Oauth Secret: ${FACEBOOK_OAUTH_SECRET} \n"
printf "Force Https: ${FORCE_SSL} \n"

printf "\n"
printf "Is this correct (y or n): "
read -n 1 CORRECT
printf "\n"

if  [ "${CORRECT}" == "y" ]; then

    if [ -f ${RUN_SCRIPT} ]; then
       rm ${RUN_SCRIPT}
    fi
    cp ${BIN}/run.sh.dist ${RUN_SCRIPT}

    sed -i -e s/__SITE_NAME__/"${SITE_NAME}"/g ${RUN_SCRIPT}
    sed -i -e s/__PORT__/"${PORT}"/g ${RUN_SCRIPT}
    sed -i -e s/__GOOGLE_SEARCH_ENGINE_ID__/"${GOOGLE_SEARCH_ENGINE_ID}"/g ${RUN_SCRIPT}
    sed -i -e s/__GOOGLE_SEARCH_KEY__/"${GOOGLE_SEARCH_KEY}"/g ${RUN_SCRIPT}
    sed -i -e s/__GOOGLE_OAUTH_KEY__/"${GOOGLE_OAUTH_KEY}"/g ${RUN_SCRIPT}
    sed -i -e s/__GOOGLE_OAUTH_SECRET__/"${GOOGLE_OAUTH_SECRET}"/g ${RUN_SCRIPT}
    sed -i -e s/__FACEBOOK_OAUTH_KEY__/"${FACEBOOK_OAUTH_KEY}"/g ${RUN_SCRIPT}
    sed -i -e s/__FACEBOOK_OAUTH_SECRET__/"${FACEBOOK_OAUTH_SECRET}"/g ${RUN_SCRIPT}
    sed -i -e s/__FORCE_SSL__/"${FORCE_SSL}"/g ${RUN_SCRIPT}
    chmod +x ${RUN_SCRIPT}

    if [ -f ${NGINX_CONF} ]; then
       rm ${NGINX_CONF}
    fi
    cp ${ETC}/nginx/nginx.dist.conf ${NGINX_CONF}

    sed -i -e "s __LOG__ $LOG g" ${NGINX_CONF}
    sed -i -e s/__SITE_DOMAINS__/"${SITE_DOMAINS}"/g ${NGINX_CONF}
    sed -i -e s/__PORT__/"${PORT}"/g ${NGINX_CONF}

printf "\n"
printf "\n"
printf "\n"
printf "================================================================\n"

    printf "Your run script has been created at: \n"
    printf "${RUN_SCRIPT}\n"
    printf "\n"
else
    printf "Please run this script again to enter the correct configuration. \n"
    printf "\n"
    printf "================================================================\n"
    exit 1
fi

if [ -f ${SERVICE_RUN_SCRIPT} ]; then
    rm ${SERVICE_RUN_SCRIPT}
fi

cp ${RUN_SCRIPT} ${SERVICE_RUN_SCRIPT}

sed -i 's/supervisord.conf/supervisord.service.conf/' ${SERVICE_RUN_SCRIPT}

printf "Creating startup script...\n"

INITD_SCRIPT="${ETC}/init.d/${SITE_NAME}.sh"
STOP_SCRIPT="${BIN}/stop.sh"

if [ -f ${INITD_SCRIPT} ]; then
   rm ${INITD_SCRIPT}
fi

cp "${ETC}/init.d/init-template.sh.dist" ${INITD_SCRIPT}

chmod +x "${INITD_SCRIPT}"

sed -i -e "s __START_SCRIPT__ $SERVICE_RUN_SCRIPT " ${INITD_SCRIPT}
sed -i -e "s __STOP_SCRIPT__ $STOP_SCRIPT " ${INITD_SCRIPT}

printf "\n"
printf "First copy the startup script into init.d by pasting this into the console:\n"
printf "sudo cp ${INITD_SCRIPT} /etc/init.d/${SITE_NAME}\n"
printf "\n";
printf "Then to run the website when the system boots paste this into the console: \n"
printf "sudo chkconfig --add ${SITE_NAME}; sudo chkconfig --level 2345 ${SITE_NAME} on\n"
printf "\n";
printf "To start the website now, use the script to start it, like this: \n"
printf "sudo /etc/init.d/${SITE_NAME} start\n"
printf "\n";
printf "================================================================\n"