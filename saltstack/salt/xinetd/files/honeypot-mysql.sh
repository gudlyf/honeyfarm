#!/bin/bash

# V1.1

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
	CID=$(/usr/bin/docker run -i -d -h "${SVR_HOSTNAME}" ${READ_ONLY} --name "${CNM}" -e "MYSQL_ROOT_PASSWORD=my-secret-pw" -p ${SERVICE_IN}:${SERVICE_OUT} mysql:latest)
    else
	# start container if exited and grab the cid
        /usr/bin/docker start "${CNM}" &> /dev/null
        CID=$(/usr/bin/docker inspect --format '{{ .Id }}' "${CNM}")
    fi
} &> /dev/null

# forward traffic to the container
/usr/bin/socat -T300 stdin tcp:${CIP}:${SERVICE_IN},retry=10

# Destroy this container once they're disconnected or idle
/usr/bin/docker kill ${CID}
/usr/bin/docker rm ${CID}
