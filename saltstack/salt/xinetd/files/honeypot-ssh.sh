#!/bin/bash

SERVICE_IN=2223
SERVICE_OUT=22
SERVICE_NAME="ssh"
CIP="127.0.0.1"

READ_ONLY="--read-only"

{
    CNM="honeypot-${SERVICE_NAME}-${REMOTE_HOST}"

    # check if the container exists
    if ! /usr/bin/docker inspect "${CNM}" &> /dev/null; then
	# create new container
	SVR_HOSTNAME=live-svr-$(( ( RANDOM % 10 )  + 1 ))
	CID=$(/usr/bin/docker run -i -d -h "${SVR_HOSTNAME}" ${READ_ONLY} --name "${CNM}" -p ${SERVICE_IN}:${SERVICE_OUT} -v /var/log/script:/var/log/script honeyfarm/${SERVICE_NAME})
    else
	# start container if exited and grab the cid
        /usr/bin/docker start "${CNM}" &> /dev/null
        CID=$(/usr/bin/docker inspect --format '{{ .Id }}' "${CNM}")
    fi
} &> /dev/null

while [ $? -ne 0 ]; do
  ssh-keyscan -p ${SERVICE_IN} ${CIP} | grep -q "OpenSSH"
  sleep 1
done

sleep 1

# forward traffic to the container
/usr/bin/socat -T300 stdin tcp:${CIP}:${SERVICE_IN},retry=5

# Destroy this container once they're disconnected or idle
#/usr/bin/docker kill ${CID}
#/usr/bin/docker rm ${CID}
