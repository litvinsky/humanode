#!/bin/bash

# REPLACE DEMO VALUES WITH YOUR VALUES
NAME=DEMO_NODE_NAME
RPC_URL=DEMO_UNIQUE_RPC_URL
NGROK_TOKEN=DEMO_NGROK_TOKEN
SECRET_PHRASE=DEMO_SECRET_PHRASE

echo "Setting up Humanode service..."
apt install curl jq -y

# move humanode folder to /root
cp humanode /root

install -m 0755 "./binaries/$(uname -s)-$(uname -m)/humanode-peer" /usr/local/bin
humanode-peer key insert --key-type aura --suri "$SECRET_PHRASE" --chain chainspec.json

# Make Humanode startup script
printf "exec 1> >(logger -t humanode) 2>&1
exec /usr/local/bin/humanode-peer --name "$NAME" --validator --chain chainspec.json --rpc-url "$RPC_URL" --rpc-cors all" > $HOME/humanode/start.sh
chmod +x $HOME/humanode/start.sh

# Create Humanode service
printf "[Unit]
Description=humanode
After=network.service

[Service]
Type=simple
User=$USER
WorkingDirectory=$HOME/humanode
ExecStart=/bin/bash $HOME/humanode/start.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/humanode.service

# Enable & run Humanode service
systemctl daemon-reload && \
systemctl enable humanode && \
systemctl start humanode && \
systemctl restart systemd-journald

# View last 50 lines of Humanode log
journalctl -u humanode -n 50 | cat

echo "Setting up Ngrok service..."

# Make Ngrok config file
rm -rf /root/.ngrok2
mkdir $HOME/.ngrok2
printf "authtoken: $NGROK_TOKEN
tunnels:
    default:
        proto: http
        addr: 9933
        bind_tls: true" > $HOME/.ngrok2/ngrok.yml

# Create Ngrok service
printf "[Unit]
Description=Ngrok
After=network.service

[Service]
type=simple
User=$USER
WorkingDirectory=$HOME/.ngrok2
ExecStart=/usr/bin/ngrok start --all --config="ngrok.yml"
Restart=on-failure

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/ngrok.service

# Enable & run Ngrok service
chmod +x /usr/bin/ngrok
systemctl daemon-reload && \ 
systemctl enable ngrok && \ 
systemctl start ngrok

# View Ngrok status
curl localhost:4040/api/tunnels | jq

systemctl status ngrok
systemctl status humanode

journalctl -u humanode -f
