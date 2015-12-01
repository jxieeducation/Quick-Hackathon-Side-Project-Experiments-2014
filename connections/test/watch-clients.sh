#!/usr/bin/zsh -ue

zmodload zsh/datetime

APIBASE=https://10.10.20.21/api

while true; do
    local name=clients-$EPOCHSECONDS.xml.gz
    curl --insecure \
	--header 'Authorization: Basic ZGV2dXNlcjpkZXZ1c2Vy' \
	--compressed \
	$APIBASE/contextaware/v1/location/clients \
	| pv \
	| gzip >$name.$$.tmp && mv $name{.$$.tmp,} \
	|| true
    sleep 60
done
