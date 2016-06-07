#!/bin/bash

: '
IP=127.0.0.1:8080
CRED=admin:admin
VPN=mqtt-poc-pub
MQTT_Port=1889
UserName=pubuser
BridgeUserName=buser
'
IP=$2:8080
CRED=admin:admin
VPN=mqtt-poc-pub-auto
MQTT_Port=1888
UserName=pubuser
BridgeUserName=buser


echo "${IP}"

Create_VPN="
<rpc semp-version=\"soltr/7_1_1\">
    <create>
        <message-vpn>
            <vpn-name>${VPN}</vpn-name>
        </message-vpn>
    </create>
</rpc>"

VPN_AuthSet="
<rpc semp-version=\"soltr/7_1_1\">
    <message-vpn>
        <vpn-name>${VPN}</vpn-name>
        <authentication>
            <user-class>
                <client></client>
                <basic>
                    <auth-type>
                        <none></none>
                    </auth-type>
                </basic>
            </user-class>
        </authentication>
    </message-vpn>
</rpc>
"

# message-vpn "mqtt-poc-sub" service mqtt listen-port 1800
VPN_MQTT_Service="
<rpc semp-version=\"soltr/7_1_1\">
    <message-vpn>
        <vpn-name>${VPN}</vpn-name>
        <service>
            <mqtt>
                <listen-port>
                    <port>${MQTT_Port}</port>
                </listen-port>
            </mqtt>
        </service>
    </message-vpn>
</rpc>
"

# message-vpn "mqtt-poc-sub" no shutdown
VPN_Start="
<rpc semp-version=\"soltr/7_1_1\">
    <message-vpn>
        <vpn-name>${VPN}</vpn-name>
        <no>
            <shutdown></shutdown>
        </no>
    </message-vpn>
</rpc>
"

# message-vpn "mqtt-poc-sub" service mqtt plain-text no shutdown
VPN_MQTT_Start="
<rpc semp-version=\"soltr/7_1_1\">
    <message-vpn>
        <vpn-name>${VPN}</vpn-name>
        <service>
            <mqtt>
                <plain-text>
                    <no>
                        <shutdown></shutdown>
                    </no>
                </plain-text>
            </mqtt>
        </service>
    </message-vpn>
</rpc>
"

# client-profile "default" message-vpn "mqtt-poc-sub" allow-bridge-connections
ClientProfile="
<rpc semp-version=\"soltr/7_1_1\">
	    <client-profile>
	        <name>default</name>
	        <vpn-name>${VPN}</vpn-name>
	        <allow-bridge-connections></allow-bridge-connections>
	    </client-profile>
</rpc>
"

CreateClientUN="
<rpc semp-version=\"soltr/7_1_1\">
    <create>
        <client-username>
            <username>${UserName}</username>
            <vpn-name>${VPN}</vpn-name>
        </client-username>
    </create>
</rpc>
"

# client-username  ${UserName} message-vpn ${VPN} acl-profile "default"
AssignCP="
<rpc semp-version=\"soltr/7_1_1\">
    <client-username>
        <username>${UserName}</username>
        <vpn-name>${VPN}</vpn-name>
        <acl-profile>
            <name>default</name>
        </acl-profile>
    </client-username>
</rpc>
"

# client-username  ${UserName} message-vpn ${VPN} client-profile "default"
AssignACL="
<rpc semp-version=\"soltr/7_1_1\">
    <client-username>
        <username>${UserName}</username>
        <vpn-name>${VPN}</vpn-name>
        <client-profile>
            <name>default</name>
        </client-profile>
    </client-username>
</rpc>
"

# client-username  ${UserName} message-vpn ${VPN} no shutdown
StartClientUN="
<rpc semp-version=\"soltr/7_1_1\">
    <client-username>
        <username>${UserName}</username>
        <vpn-name>${VPN}</vpn-name>
        <no>
            <shutdown></shutdown>
        </no>
    </client-username>
</rpc>
"

CreateClientUN_BR="
<rpc semp-version=\"soltr/7_1_1\">
    <create>
        <client-username>
            <username>${BridgeUserName}</username>
            <vpn-name>${VPN}</vpn-name>
        </client-username>
    </create>
</rpc>
"

AssignCP_BR="
<rpc semp-version=\"soltr/7_1_1\">
    <client-username>
        <username>${BridgeUserName}</username>
        <vpn-name>${VPN}</vpn-name>
        <acl-profile>
            <name>default</name>
        </acl-profile>
    </client-username>
</rpc>
"

AssignACL_BR="
<rpc semp-version=\"soltr/7_1_1\">
    <client-username>
        <username>${BridgeUserName}</username>
        <vpn-name>${VPN}</vpn-name>
        <client-profile>
            <name>default</name>
        </client-profile>
    </client-username>
</rpc>
"

StartClientUN_BR="
<rpc semp-version=\"soltr/7_1_1\">
    <client-username>
        <username>${BridgeUserName}</username>
        <vpn-name>${VPN}</vpn-name>
        <no>
            <shutdown></shutdown>
        </no>
    </client-username>
</rpc>
"

# *************************************************************** #

ShutdownClientUN="
<rpc semp-version=\"soltr/7_1_1\">
    <client-username>
        <username>${UserName}</username>
        <vpn-name>${VPN}</vpn-name>
            <shutdown></shutdown>
    </client-username>
</rpc>
"

DeleteClientUN="
<rpc semp-version=\"soltr/7_1_1\">
	<no>
	    <client-username>
	        <username>${UserName}</username>
	        <vpn-name>${VPN}</vpn-name>
	    </client-username>
    </no>
</rpc>
"

ShutdownClientUN_BR="
<rpc semp-version=\"soltr/7_1_1\">
    <client-username>
        <username>${BridgeUserName}</username>
        <vpn-name>${VPN}</vpn-name>
            <shutdown></shutdown>
    </client-username>
</rpc>
"

DeleteClientUN_BR="
<rpc semp-version=\"soltr/7_1_1\">
    <no>
        <client-username>
            <username>${BridgeUserName}</username>
            <vpn-name>${VPN}</vpn-name>
        </client-username>
    </no>
</rpc>
"

ShutdownVPN="
<rpc semp-version=\"soltr/7_1_1\">
    <message-vpn>
        <vpn-name>${VPN}</vpn-name>
        <shutdown></shutdown>
    </message-vpn>
</rpc>
"

DeleteVPN="
<rpc semp-version=\"soltr/7_1_1\">
  <no>
    <message-vpn>
      <vpn-name>${VPN}</vpn-name>
    </message-vpn>
  </no>
</rpc>
"

if test $1 == "Delete"
then
	echo "Cleaning the VPN..."
	echo "${ShutdownClientUN}" | curl -d @- -u "${CRED}" http://${IP}/SEMP
	echo "${DeleteClientUN}" | curl -d @- -u "${CRED}" http://${IP}/SEMP
    echo "${ShutdownClientUN_BR}" | curl -d @- -u "${CRED}" http://${IP}/SEMP
    echo "${DeleteClientUN_BR}" | curl -d @- -u "${CRED}" http://${IP}/SEMP
	echo "${ShutdownVPN}" | curl -d @- -u "${CRED}" http://${IP}/SEMP
	echo "${DeleteVPN}" | curl -d @- -u "${CRED}" http://${IP}/SEMP

elif test $1 == "Create"
then
	echo "Provisioning the VPN..."
	echo "${Create_VPN}" | curl -d @- -u "${CRED}" http://${IP}/SEMP
	echo "${VPN_AuthSet}" | curl -d @- -u "${CRED}" http://${IP}/SEMP
	echo "${VPN_MQTT_Service}" | curl -d @- -u "${CRED}" http://${IP}/SEMP
	echo "${VPN_Start}" | curl -d @- -u "${CRED}" http://${IP}/SEMP
	echo "${VPN_MQTT_Start}" | curl -d @- -u "${CRED}" http://${IP}/SEMP
	echo "${ClientProfile}" | curl -d @- -u "${CRED}" http://${IP}/SEMP
	echo "${CreateClientUN}" | curl -d @- -u "${CRED}" http://${IP}/SEMP
	echo "${AssignCP}" | curl -d @- -u "${CRED}" http://${IP}/SEMP
	echo "${AssignACL}" | curl -d @- -u "${CRED}" http://${IP}/SEMP
	echo "${StartClientUN}" | curl -d @- -u "${CRED}" http://${IP}/SEMP
    echo "${CreateClientUN_BR}" | curl -d @- -u "${CRED}" http://${IP}/SEMP
    echo "${AssignCP_BR}" | curl -d @- -u "${CRED}" http://${IP}/SEMP
    echo "${AssignACL_BR}" | curl -d @- -u "${CRED}" http://${IP}/SEMP
    echo "${StartClientUN_BR}" | curl -d @- -u "${CRED}" http://${IP}/SEMP

else
	echo "Invalid option provided to script - either provide Create or Delete"
fi


