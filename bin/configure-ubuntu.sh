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
LOG="${DIR}/error.log"
RUN_SCRIPT="${BIN}/run-ubuntu.sh"
SERVICE_RUN_SCRIPT="${BIN}/run-ubuntu-service.sh"
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
    GOOGLE_OAUTH_SECRET="GOOGLE_OAUTH_SECRET"
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
sed -i -e s/"supervisord.conf"/"supervisord.service.conf"/g ${SERVICE_RUN_SCRIPT}

VERSION=$(lsb_release -r | cut -d : -f 2- | sed 's/^[ \t]*//;s/[ \t]*$//')
MAJOR_VERSION=$(echo "${VERSION%%.*}")
if [ "${MAJOR_VERSION}" -gt "14" ]; then
    printf "version: ${VERSION} detected. Creating systemd job...\n"
    SYSTEMD_CONF_FILE="${ETC}/${SITE_NAME}.service"
    if [ -f ${SYSTEMD_CONF_FILE} ]; then
       rm ${SYSTEMD_CONF_FILE}
    fi

    printf "[Unit]\n" >> ${SYSTEMD_CONF_FILE}
    printf "Description=Service for running the ${SITE_NAME} website\n" >> ${SYSTEMD_CONF_FILE}
    printf "After=network.target\n" >> ${SYSTEMD_CONF_FILE}
    printf "\n" >> ${SYSTEMD_CONF_FILE}
    printf "[Service]\n" >> ${SYSTEMD_CONF_FILE}
    printf "Type=forking\n" >> ${SYSTEMD_CONF_FILE}
    printf "WorkingDirectory=${DIR}\n" >> ${SYSTEMD_CONF_FILE}
    printf "ExecStop=${BIN}/stop.sh\n" >> ${SYSTEMD_CONF_FILE}
    printf "ExecStart=${SERVICE_RUN_SCRIPT}\n" >> ${SYSTEMD_CONF_FILE}
    printf "KillMode=process\n" >> ${SYSTEMD_CONF_FILE}
    printf "\n" >> ${SYSTEMD_CONF_FILE}
    printf "[Install]\n" >> ${SYSTEMD_CONF_FILE}
    printf "WantedBy=multi-user.target\n" >> ${SYSTEMD_CONF_FILE}
    printf "\n"
    printf "A systemd configuration has been created\n"
    printf "To enable the website as a service run the following:\n"
    printf "sudo systemctl enable ${SYSTEMD_CONF_FILE}\n"
    printf "\n";
    printf "Then you can start the service manually like this:\n"
    printf "sudo systemctl start ${SITE_NAME}\n"
    printf "================================================================\n"
else
    printf "version: ${VERSION} detected. Creating upstart job...\n"
    UPSTART_CONF_FILE="${ETC}/${SITE_NAME}.conf"
    if [ -f ${UPSTART_CONF_FILE} ]; then
       rm ${UPSTART_CONF_FILE}
    fi
    printf "# ${SITE_NAME} service\n" >> ${UPSTART_CONF_FILE}
    printf "\n"  >> ${UPSTART_CONF_FILE}
    printf "description \"Service for running the ${SITE_NAME} website\"\n" >> ${UPSTART_CONF_FILE}
    printf "author \"Jesse Greathouse <jesse@greathouse.technology>\" \n" >> ${UPSTART_CONF_FILE}
    printf "\n" >> ${UPSTART_CONF_FILE}
    printf "chdir ${DIR}\n" >> ${UPSTART_CONF_FILE}
    printf "\n" >> ${UPSTART_CONF_FILE}
    printf "start on runlevel [2345]\n" >> ${UPSTART_CONF_FILE}
    printf "stop on runlevel [016]\n" >> ${UPSTART_CONF_FILE}
    printf "\n" >> ${UPSTART_CONF_FILE}
    printf "exec ${SERVICE_RUN_SCRIPT}\n" >> ${UPSTART_CONF_FILE}
    printf "An upstart configuration has been created. To run the website as a service copy and paste this line:\n"
    printf "sudo cp ${UPSTART_CONF_FILE} /etc/init/\n"
    printf "\n"
    printf "Then, you can start the service manually like this::\n"
    printf "sudo service ${SITE_NAME} start\n"
    printf "================================================================\n"
fi
