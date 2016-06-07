#!/bin/bash


for ip in $(cat ./ScriptedDeployment/PubHosts.txt)
do
    ./mqtt-poc-pub-semp-xml.sh $1 $ip
done

for ip in $(cat ./ScriptedDeployment/SubHosts.txt)
do
    ./mqtt-poc-sub-semp-xml.sh $1 $ip
done
