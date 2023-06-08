#!/bin/bash
# Example from https://github.com/smallstep/docker-tls/blob/main/mongodb/entrypoint-shim.sh heavily modified

shutdown() {
	echo "sutting down"
	pids=$(ps S | awk '{print  $  1 }' | grep -E '[0-9]')
	for i in ${pids[@]}; do
		if [ "$i" = "1" ]; then
			continue
		fi
		kill $i
	done
	exit 0
}

/app/tls-scripts/get-ca.sh
/app/tls-scripts/get-cert.sh
errorcode=$?

trap shutdown HUP INT QUIT TERM

echo -e "\033[1;37mExecuting\033[0;m \033[0;35m$EXEC_SCRIPT \033[0;36m$EXEC_ARGS\033[0;m ..."
#script path arguments  extra arguments specified using CMD (see https://docs.docker.com/engine/reference/builder/#cmd)
"$EXEC_SCRIPT" $EXEC_ARGS $@ &
if [ "$errorcode" -eq 0 ]; then
	/app/tls-scripts/renew-cert.sh
fi

echo "waiting for process control signal ..."
wait