#!/bin/bash

# V1.1

SERVICE_IN=2223
SERVICE_OUT=22

READ_ONLY="--read-only"

{
    CNM="honeypot-ssh-${REMOTE_HOST}"

    # check if the container exists
    if ! /usr/bin/docker inspect "${CNM}" &> /dev/null; then
	# create new container
	SVR_HOSTNAME=live-svr-$(( ( RANDOM % 10 )  + 1 ))
	CID=$(/usr/bin/docker run -h ${SVR_HOSTNAME} ${READ_ONLY} -d --name ${CNM} -p ${SERVICE_IN}:${SERVICE_OUT} -d -i honeyfarm/ssh)
	CIP=$(/usr/bin/docker inspect --format '{{ .NetworkSettings.IPAddress }}' ${CID})
	CIP="127.0.0.1"
    else
	# start container if exited and grab the cid
        /usr/bin/docker start "${CNM}" &> /dev/null
        CID=$(/usr/bin/docker inspect --format '{{ .Id }}' "${CNM}")
	CIP=$(/usr/bin/docker inspect --format '{{ .NetworkSettings.IPAddress }}' ${CID})
	CIP="127.0.0.1"
    fi
} &> /dev/null

# forward traffic to the container
/usr/bin/socat -T300 stdin tcp:${CIP}:${SERVICE_IN},retry=5

# Destroy this container once they're disconnected or idle
/usr/bin/docker kill ${CID}
/usr/bin/docker rm ${CID}
