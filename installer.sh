#!/bin/bash

# REPLACE DEMO VALUES WITH YOUR VALUES
NAME=DEMO_NODE_NAME
RPC_URL=DEMO_UNIQUE_RPC_URL
NGROK_TOKEN=DEMO_NGROK_TOKEN

echo "Setting up Humanode service..."
apt install curl jq -y

# Make Humanode startup script
printf "exec 1> >(logger -t humanode) 2>&1
exec /usr/local/bin/humanode-peer --name "$NAME" --validator --chain chainspec.json --rpc-url "$RPC_URL" --rpc-cors all" > $HOME/humanode/start.sh
chmod +x $HOME/humanode/start.sh

# Create Humanode service
printf "[Unit]
Description=humanode
After=network.service

[Service]
type=simple
User=$USER
WorkingDirectory=$HOME/humanode
ExecStart=$HOME/humanode/start.sh
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
systemctl daemon-reload && \ 
systemctl enable ngrok && \ 
systemctl start ngrok

# View Ngrok status
curl localhost:4040/api/tunnels | jq
