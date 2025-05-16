





curl -so wazuh-agent-4.3.11.deb https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent_4.3.11-1_amd64.deb && sudo WAZUH_MANAGER='wazuh-dashboard-esuscloud.brasilcloud.net' WAZUH_AGENT_GROUP='e-sus' dpkg -i ./wazuh-agent-4.3.11.deb
sudo systemctl daemon-reload
sudo systemctl enable wazuh-agent
sudo systemctl start wazuh-agent