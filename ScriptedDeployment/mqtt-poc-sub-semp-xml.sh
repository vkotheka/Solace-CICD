#!/bin/bash

: '
IP=127.0.0.1:8080
CRED=admin:admin
VPN=mqtt-poc-sub
MQTT_Port=1888
UserName=subuser
PubVPNForBr=mqtt-poc-pub-auto
ConnectVia=127.0.0.1:55555
'

IP=$2:8080
CRED=admin:admin
VPN=mqtt-poc-sub-auto
MQTT_Port=1888
UserName=subuser
PubVPNForBr=mqtt-poc-pub-auto
ConnectVia=172.31.35.79:55555

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

# ************** Bridge Scripts *************** 

Create_BR="
<rpc semp-version=\"soltr/7_1_1\">
    <create>
        <bridge>
            <bridge-name>mqtt-br</bridge-name>
            <vpn-name>${VPN}</vpn-name>
            <primary></primary>
        </bridge>
    </create>
</rpc>
"

AssignUser_BR="
<rpc semp-version=\"soltr/7_1_1\">
    <bridge>
        <bridge-name>mqtt-br</bridge-name>
        <vpn-name>${VPN}</vpn-name>
        <primary></primary>
        <remote>
            <authentication>
                <basic>
                    <client-username>
                        <name>buser</name>
                    </client-username>
                </basic>
            </authentication>
        </remote>
    </bridge>
</rpc>
"

# bridge "mqtt-br" message-vpn "mqtt-poc-sub" primary remote create message-vpn ${PubVPNForBr} connect-via ${ConnectVia} interface 1/1/lag1 
CreateRemote_BR="
<rpc semp-version=\"soltr/7_1_1\">
    <bridge>
        <bridge-name>mqtt-br</bridge-name>
        <vpn-name>${VPN}</vpn-name>
        <primary></primary>
        <remote>
        	<create>
	            <message-vpn>
	                <vpn-name>${PubVPNForBr}</vpn-name>
	                <connect-via></connect-via>
	                <addr>${ConnectVia}</addr>
	                <interface></interface>
	                <phys-intf>1/1/lag1</phys-intf>
	            </message-vpn>
            </create>	
        </remote>
    </bridge>
</rpc>
"

# bridge "mqtt-br" message-vpn ${VPN} primary remote subscription-topic >
AddSubscription_BR="
<rpc semp-version=\"soltr/7_1_1\">
    <bridge>
        <bridge-name>mqtt-br</bridge-name>
        <vpn-name>${VPN}</vpn-name>
        <primary></primary>
        <remote>
            <subscription-topic>
                <topic>></topic>
            </subscription-topic>
        </remote>
    </bridge>
</rpc>
"

# bridge "mqtt-br" message-vpn "mqtt-poc-sub" primary no shutdown
StartLocal_BR="
<rpc semp-version=\"soltr/7_1_1\">
    <bridge>
        <bridge-name>mqtt-br</bridge-name>
        <vpn-name>${VPN}</vpn-name>
        <primary></primary>
        <no>
            <shutdown></shutdown>
        </no>
    </bridge>
</rpc>
"

# bridge "mqtt-br" message-vpn "mqtt-poc-sub" primary remote message-vpn ${PubVPNForBr} connect-via ${ConnectVia} interface 1/1/lag1 no shutdown
StartRemote_BR="
<rpc semp-version=\"soltr/7_1_1\">
    <bridge>
        <bridge-name>mqtt-br</bridge-name>
        <vpn-name>${VPN}</vpn-name>
        <primary></primary>
        <remote>
            <message-vpn>
                <vpn-name>${PubVPNForBr}</vpn-name>
                <connect-via></connect-via>
                <addr>${ConnectVia}</addr>
                <interface></interface>
                <phys-intf>1/1/lag1</phys-intf>
                <no>
                    <shutdown></shutdown>
                </no>
            </message-vpn>
        </remote>
    </bridge>
</rpc>
"

# ****************************************************

Shutdown_BR="
<rpc semp-version=\"soltr/7_1_1\">
    <bridge>
        <bridge-name>mqtt-br</bridge-name>
        <vpn-name>${VPN}</vpn-name>
        <shutdown></shutdown>
    </bridge>
</rpc>
"

Shutdown_Remote="
<rpc semp-version=\"soltr/7_1_1\">
    <bridge>
        <bridge-name>mqtt-br</bridge-name>
        <vpn-name>${VPN}</vpn-name>
        <primary></primary>
        <remote>
            <message-vpn>
                <vpn-name>${PubVPNForBr}</vpn-name>
                <connect-via></connect-via>
                <addr>${ConnectVia}</addr>
                <interface></interface>
                <phys-intf>1/1/lag1</phys-intf>
               	<shutdown></shutdown>
            </message-vpn>
        </remote>
    </bridge>
</rpc>
"

# no bridge "mqtt-br" message-vpn ${VPN}
Delete_BR="
<rpc semp-version=\"soltr/7_1_1\">
    <no>
        <bridge>
            <bridge-name>mqtt-br</bridge-name>
            <vpn-name>${VPN}</vpn-name>
        </bridge>
    </no>
</rpc>
"

if test $1 == "Delete"
then
	echo "Cleaning the VPN..."
	echo "${Shutdown_BR}" | curl -d @- -u "${CRED}" http://${IP}/SEMP
	echo "${Shutdown_Remote}" | curl -d @- -u "${CRED}" http://${IP}/SEMP
	echo "${Delete_BR}" | curl -d @- -u "${CRED}" http://${IP}/SEMP

	echo "${ShutdownClientUN}" | curl -d @- -u "${CRED}" http://${IP}/SEMP
	echo "${DeleteClientUN}" | curl -d @- -u "${CRED}" http://${IP}/SEMP
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

	echo "${Create_BR}" | curl -d @- -u "${CRED}" http://${IP}/SEMP
	echo "${AssignUser_BR}" | curl -d @- -u "${CRED}" http://${IP}/SEMP
	echo "${CreateRemote_BR}" | curl -d @- -u "${CRED}" http://${IP}/SEMP
	echo "${AddSubscription_BR}" | curl -d @- -u "${CRED}" http://${IP}/SEMP
	echo "${StartLocal_BR}" | curl -d @- -u "${CRED}" http://${IP}/SEMP
	echo "${StartRemote_BR}" | curl -d @- -u "${CRED}" http://${IP}/SEMP
else
	echo "Invalid option provided to script - either provide Create or Delete"
fi


