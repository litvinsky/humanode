#!/bin/bash

# REPLACE DEMO VALUES WITH YOUR VALUES
NAME=DEMO_NODE_NAME
NGROK_TOKEN=DEMO_NGROK_TOKEN
SECRET_PHRASE=DEMO_SECRET_PHRASE
USER_HOME="/home/your_user_name"

echo "Check for humanode & ngrok services..."
if [ -f /etc/systemd/system/humanode.service ]
	then
		systemctl stop humanode&& \
		systemctl disable humanode
		sleep 2
fi

if [ -f /etc/systemd/system/ngrok.service ]
	then
		systemctl stop ngrok&& \
		systemctl disable ngrok
		sleep 2
fi

echo "Install packages ..."
apt install curl jq wget unzip -y
sleep 2

if [ -f /usr/bin/ngrok ]
	then
		echo "Found ngrok in /usr/bin ..."
	else
		wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
		unzip ngrok-stable-linux-amd64.zip
		rm ngrok-stable-linux-amd64.zip
		mv ./ngrok /usr/bin/ngrok
		chmod +x /usr/bin/ngrok
		sleep 2
fi

echo Copy new files from $USER_HOME/humanode to $HOME/humanode ...
#move humanode folder to /root
if [ -d $USER_HOME/humanode ]
	then
		echo Found $HOME/humanode ...
		sleep 2
		mkdir $HOME/humanode
		cp $USER_HOME/humanode/chainspec.json $HOME/humanode/chainspec.json
		cp $USER_HOME/humanode/binaries/$(uname -s)-$(uname -m)/humanode-peer $HOME/humanode/humanode-peer
		sleep 2
	else
		echo TODO: unzip humanode-testnet1.zip $USER_HOME/humanode \
			 then run that script again ...
		exit
fi

echo "Configure & run ngrok.service..."
# Make Ngrok config file
rm -rf $HOME/.ngrok2
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
Type=simple
User=$USER
WorkingDirectory=$HOME/.ngrok2
ExecStart=/usr/bin/ngrok start --all --config="ngrok.yml"
Restart=on-failure

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/ngrok.service

systemctl daemon-reload
# Enable & run Ngrok service
systemctl enable ngrok && \
systemctl start ngrok && \
systemctl status ngrok
# View Ngrok status
# curl localhost:4040/api/tunnels | jq 
curl localhost:4040/api/tunnels | jq > $HOME/humanode/ngrok_tunnels.json
RPC_URL=$(echo "$public_url" | jq '.tunnels[0].public_url' $HOME/humanode/ngrok_tunnels.json)
sleep 2

cd $HOME/humanode
install -m 0755 "humanode-peer" /usr/local/bin
humanode-peer key insert --key-type aura --suri "$SECRET_PHRASE" --chain chainspec.json
echo "Make Humanode startup script ..."
printf "exec 1> >(logger -t humanode) 2>&1
exec /usr/local/bin/humanode-peer --name "$NAME" --validator --chain chainspec.json --rpc-url "$RPC_URL" --rpc-cors all" > $HOME/humanode/start.sh
chmod +x $HOME/humanode/start.sh
ls
sleep 2
 
# View last 50 lines of Humanode log
# journalctl -u humanode -n 50 | cat

echo "Configure & run humanode.service..."
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

systemctl daemon-reload
# Enable & run Humanode service
systemctl enable humanode && \
systemctl start humanode && \
systemctl restart systemd-journal

systemctl status humanode
journalctl -u humanode -f

# View Ngrok status
curl localhost:4040/api/tunnels | jq

systemctl status ngrok
systemctl status humanode

journalctl -u humanode -f
