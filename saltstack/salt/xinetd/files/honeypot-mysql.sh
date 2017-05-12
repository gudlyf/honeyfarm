#!/bin/bash

SERVICE_IN=3366
SERVICE_OUT=3306
SERVICE_NAME=mysql
CIP="127.0.0.1"

#READ_ONLY="--read-only"

{
    CNM="honeypot-${SERVICE_NAME}-${REMOTE_HOST}"

    # check if the container exists
    if ! /usr/bin/docker inspect "${CNM}" &> /dev/null; then
	# create new container
	SVR_HOSTNAME=live-db-$(( ( RANDOM % 10 )  + 1 ))
	#CID=$(/usr/bin/docker run -i -d -h "${SVR_HOSTNAME}" ${READ_ONLY} --name "${CNM}" -e "MYSQL_ROOT_PASSWORD=root" -p ${SERVICE_IN}:${SERVICE_OUT} mysql:5.7 --ssl=FALSE)
	CID=$(/usr/bin/docker run -i -d -h "${SVR_HOSTNAME}" ${READ_ONLY} --name "${CNM}" -e "MYSQL_ROOT_PASSWORD=root" -p ${SERVICE_OUT} mysql:5.7 --ssl=FALSE)
	SERVICE_IN=$(/usr/bin/docker inspect --format '{{ (index (index .NetworkSettings.Ports "${SERVICE_OUT}/tcp") 0).HostPort }}' ${CID})
3366
    else
	# start container if exited and grab the cid
        /usr/bin/docker start "${CNM}" &> /dev/null
        CID=$(/usr/bin/docker inspect --format '{{ .Id }}' "${CNM}")
	SERVICE_IN=$(/usr/bin/docker inspect --format '{{ (index (index .NetworkSettings.Ports "${SERVICE_OUT}/tcp") 0).HostPort }}' ${CID})
    fi
} &> /dev/null

while [ $? -ne 0 ]; do
  echo quit | telnet ${CIP} ${SERVICE_IN} 2>/dev/null | grep -q Connected
  sleep 1
done

# Wait for initial spin-up
sleep 5

# forward traffic to the container
#/usr/bin/socat -T300 stdin tcp:${CIP}:${SERVICE_IN},retry=5
SOCAT_SYSTEM_CMD="SYSTEM:'/usr/bin/tee /tmp/input-"${REMOTE_HOST}" | /usr/bin/socat - \"TCP4:"${CIP}":"${SERVICE_IN}"\" | /usr/bin/tee /tmp/output-"${REMOTE_HOST}"'"
/usr/bin/socat STDIN "${SOCAT_SYSTEM_CMD}"
#/usr/bin/socat STDIN SYSTEM:'/usr/bin/tee /tmp/input-${REMOTE_HOST} | ${SOCAT_TCP} | /usr/bin/tee /tmp/output-${REMOTE_HOST}'
# Archive input/output files
DATESTAMP=$(date +%s)
mv -f /tmp/input-${REMOTE_HOST} /tmp/input-${REMOTE_HOST}_${DATESTAMP}
mv -f /tmp/output-${REMOTE_HOST} /tmp/output-${REMOTE_HOST}_${DATESTAMP}

# Destroy this container once they're disconnected or idle
#/usr/bin/docker kill ${CID}
#/usr/bin/docker rm ${CID}
