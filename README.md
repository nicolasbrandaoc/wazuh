# wazuh
# 🚀 Wazuh Projects Repository
curl -sO https://packages.wazuh.com/4.3/wazuh-install.sh; bash wazuh-install.sh --all-in-one


https://github.com/nicolasbrandaoc/wazuh.git



_____________________________________________________________________
Fortigate Installation
Copy the decoders and rules to your Wazuh Manager

Copy 0100-fortigate_decoders.xml to /var/ossec/etc/decoders/
Copy 0391-fortigate_rules.xml to /var/ossec/etc/rules/
Restart the Wazuh Manager

systemctl restart wazuh-manager

_____________________________________________________________________


Step 1: Configure Wazuh Manager to Receive Syslog Messages
Follow the guide at Wazuh Blog to configure your Wazuh manager to receive Syslog messages.

Step 2: Deploy Mikrotik Decoders and Rules
Copy 1001-mikrotik_decoders.xml to the Wazuh decoders directory:

cp /path/to/1001-mikrotik_decoders.xml /var/ossec/etc/decoders/1001-mikrotik_decoders.xml
or if you are using Docker, run:

docker cp /path/to/1001-mikrotik_decoders.xml single-node-wazuh.manager-1:/var/ossec/etc/decoders/1001-mikrotik_decoders.xml
Copy local_rules.xml to the Wazuh rules directory:

cp /path/to/local_rules.xml /var/ossec/etc/rules/local_rules.xml
or if you are using Docker, run:

docker cp /path/to/local_rules.xml single-node-wazuh.manager-1:/var/ossec/etc/rules/local_rules.xml
Step 3: Restart Wazuh
Restart the Wazuh manager to apply the new configurations:
systemctl restart wazuh-manager
or if you are using Docker, run:
docker restart single-node-wazuh.manager-1
Step 4: Configure Mikrotik to Send Logs to Syslog Server (Wazuh)
Configure the remote logging server:

/system logging action add name=remote target=remote remote=YOUR_WAZUH_SERVER_IP
Add a logging rule to send all logs to the remote server:

/system logging add action=remote topics=system
/system logging add action=remote topics=info
Make sure to replace YOUR_WAZUH_SERVER_IP with the IP address of your Wazuh server.

Step 5: Monitor Wireguard Peers Activity
Copy the script script.rsc from the repository to your Mikrotik device.

Import and execute the script from the Mikrotik terminal:

/import script.rsc
ℹ️ Note: It is crucial to assign a unique comment to each Wireguard peer configured on your Mikrotik server. This comment acts as an identifier in the monitoring script and ensures accurate tracking of each peer's activity.

Author
👤 Giuseppe Trifilio

Website: https://github.com/angolo40/WazuhMikrotik
GitHub: @angolo40
🤝 Contributing
Contributions, issues, and feature requests are welcome! Feel free to check the issues page.

Show your support
Give a ⭐️ if this project helped you!

XMR: 87LLkcvwm7JUZAVjusKsnwNRPfhegxe73X7X3mWXDPMnTBCb6JDFnspbN8qdKZA6StHXqnJxMp3VgRK7DcS2sgnW3wH7Xhw



_____________________________________________________________________

